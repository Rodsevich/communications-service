import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:nidus_smpt/src/db/db.dart';
import 'package:nidus_smpt/src/enums.dart';
import 'package:nidus_smpt/src/models/email/email.dart';
import 'package:retry/retry.dart';

/// {@template nidus_smpt}
/// Nidus SMPT
/// {@endtemplate}
class NidusSmpt {
  /// {@macro nidus_smpt}
  NidusSmpt({
    required this.email,
    required this.password,
    required this.displayName,
    required this.variant,
    required this.database,
  }) {
    try {
      switch (variant) {
        case SmptVariant.gmail:
          _smtpServer = gmail(email, password);
        case SmptVariant.outlook:
          _smtpServer = SmtpServer(
            'smtp-mail.outlook.com',
            username: email,
            password: password,
          );
        // Add more cases for other variants if needed
      }

      _from = Address(email, displayName);
      log.finest('NidusSmpt instance created with ${variant.name} variant');
    } catch (e, st) {
      log.shout('Error while creating NidusSmpt instance', e, st);
      rethrow;
    }
  }

  /// This is the main connection to the SMPT to use for sending emails.
  late final SmtpServer _smtpServer;

  /// This is the address to use for sending emails.
  late final Address _from;

  /// This is the email to use for sending emails.
  final String email;

  /// This is the display name to use for sending emails.
  final String displayName;

  /// This is the password of the account to use for sending emails.
  final String password;

  /// This is the variant of the SMTP server.
  final SmptVariant variant;

  /// This is the headers to use for sending emails.
  final Map<String, dynamic> _alwaysHeaders = {
    'Content-Type': 'text/html; charset=UTF-8',
  };

  /// This is the connection to the database.
  final Database database;

  /// This is the logger for this class.
  final log = Logger('NidusSmpt');

  /// This method sends an email to the recipient.
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String htmlBody,
    DateTime? sentAt,
    List<Attachment>? attachments,
  }) async {
    log.info('Sending email to $to');
    final message = Message()
      ..from = _from
      ..headers = _alwaysHeaders
      ..recipients.add(to)
      ..subject = subject
      ..html = htmlBody
      ..attachments = attachments ?? [];

    if (sentAt != null) {
      await _addToEmailQueue(
        message: message,
        status: EmailStatus.queued,
      );

      log.finer('Email added to queue for $to');
      return;
    }

    try {
      await retry(
        () => send(message, _smtpServer),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 8,
      );

      await _markEmailAsSent(message);

      log.fine('Email sent successfully to $to');
    } on Exception catch (e, st) {
      log.severe('We should handle this error', e, st);
      await _addToEmailQueue(message: message, status: EmailStatus.failed);
      rethrow;
    }
  }

  /// This method mark the email as read.
  Future<void> markEmailAsRead(Email email) async {
    try {
      await database.updateEmailAsRead(
        email.email,
      );
    } catch (e, st) {
      log.severe('We should handle', e, st);
      rethrow;
    }
  }

  /// This method will fetch all the emails in the queue and send them. it will
  /// avoid sending the emails with sentAt different than [DateTime.now()].
  // Future<void> resendEmailsInQueue() async {
  //   try {
  //     final emails = await database.fetchEmailsInQueue();

  //     if (emails.isNotEmpty) {
  //       log.finest('Fetched ${emails.length} emails from queue');
  //       for (final email in emails) {
  //         if (email.sentat != DateTime.now()) continue;

  //         await sendEmail(
  //           to: email.to,
  //           subject: email.subject,
  //           htmlBody: email.body,
  //         );
  //         await _deleteEmailInQueue(email.id);
  //       }
  //     }

  //     return;
  //   } catch (e, st) {
  //     log.severe('We should handle', e, st);
  //     rethrow;
  //   }
  // }

  /// This method will add and email to the queue. it could be a email
  /// that failed to send or a scheduled email.
  Future<void> _addToEmailQueue({
    required Message message,
    required EmailStatus status,
  }) async {
    try {
      await database.insertEmailToQueue(
        email: message.recipients.first.toString(),
        subject: message.subject ?? '',
        body: message.html ?? '',
        status: status,
      );
      log.finer('Email ${message.subject} added to the queue');
    } catch (e, st) {
      log.severe('We should handle', e, st);
      rethrow;
    }
  }

  /// This method will mark an email as sent and added to the correct table
  /// on the database.
  Future<void> _markEmailAsSent(Message message) async {
    try {
      await database.insertEmailSent(
        email: message.recipients.first.toString(),
        subject: message.subject ?? '',
        body: message.html ?? '',
      );
      log.finer('Email sent to ${message.recipients.first}');
    } catch (e, st) {
      log.severe('We should handle', e, st);
      rethrow;
    }
  }

  /// This method will delete a email in the queue table.
  Future<void> _deleteEmailInQueue(int id) async {
    try {
      await database.deleteEmailsInQueue(id);
      log.finer('Email with id: $id, deleted from queue');
      return;
    } catch (e, st) {
      log.severe('We should handle', e, st);
      rethrow;
    }
  }
}
