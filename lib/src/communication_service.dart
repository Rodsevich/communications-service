import 'dart:async';
import 'dart:io';

import 'package:communication_service/communication_service.dart';
import 'package:communication_service/src/delegates/persistance/persistance_delegate.dart';
import 'package:communication_service/src/extensions/extensions.dart';
import 'package:communication_service/src/models/email/email.dart';
import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:retry/retry.dart';

/// {@template CommunicationService}
/// Nidus CommunicationService
/// {@endtemplate}
class CommunicationService {
  /// {@macro CommunicationService}
  CommunicationService({
    required PersistanceDelegate persistanceDelegate,

    /// This is the email to use for sending emails.
    required String email,

    /// This is the display name to use for sending emails.
    required String displayName,

    /// This is the password of the account to use for sending emails.
    required String password,

    /// This is the variant of the SMTP server.
    // TODO(andre): deberia ser una clase
    required ServerProvider serverProvider,
  }) : _persistanceDelegate = persistanceDelegate {
    try {
      _persistanceDelegate.setUp();

      logger.finest('Communication Service instance created');
    } catch (e, st) {
      logger.shout(
        'Error while creating Communication Service instance',
        e,
        st,
      );
      rethrow;
    }

    switch (serverProvider) {
      case ServerProvider.gmail:
        _smtpServer = gmail(email, password);
      case ServerProvider.outlook:
        _smtpServer = SmtpServer(
          'smtp-mail.outlook.com',
          username: email,
          password: password,
        );
      // Add more cases for other variants if needed
    }

    _from = Address(email, displayName);
  }

  /// This is the main connection to the SMPT to use for sending emails.
  late final SmtpServer _smtpServer;

  /// This is the address to use for sending emails.
  late final Address _from;

  ///
  late final PersistanceDelegate _persistanceDelegate;

  ///
  PersistanceDelegate get persistanceDelegate => _persistanceDelegate;

  /// This is the headers to use for sending emails.
  final Map<String, dynamic> _alwaysHeaders = {
    'Content-Type': 'text/html; charset=UTF-8',
  };

  /// This is the logger for this class.
  final logger = Logger('CommunicarionService');

  /// This method sends an email to the recipient.
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String htmlBody,
    DateTime? sentAt,
    int? followUpDays,
    List<Attachment>? attachments,
  }) async {
    logger.info('Sending email to $to');
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

      logger.finer('Email added to queue for $to');
      return;
    }

    try {
      await retry(
        () => send(message, _smtpServer),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 8,
      );

      await _markEmailAsSent(message: message, followUpDays: followUpDays);

      logger.fine('Email sent successfully to $to');
      return;
    } on Exception catch (e, st) {
      logger.severe('We should handle this error', e, st);
      await _addToEmailQueue(message: message, status: EmailStatus.failed);
      rethrow;
    }
  }

  /// This method will fetch all emails is a range.
  Future<List<Email>> fetchEmailsInDateRange(DateTime date) async {
    try {
      final emails = await _persistanceDelegate.fetchEmailsInDateRange(date);
      return emails;
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }

  /// This method will fetch all the emails in the queue and send them. it will
  /// avoid sending the emails with sentAt different than [DateTime.now()].
  Future<void> resendEmailsInQueue() async {
    try {
      final emails = await _persistanceDelegate.fetchEmailsInQueue();

      if (emails.isNotEmpty) {
        logger.finest('Fetched ${emails.length} emails from queue');
        for (final email in emails) {
          if (email.sentAt != DateTime.now()) continue;

          await sendEmail(
            to: email.email,
            subject: email.subject,
            htmlBody: email.body,
          );
          await deleteEmailInQueue(email.id);
        }
      }

      return;
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }

  ///
  Future<void> sendEmailsWithFollowUp() async {
    try {
      final emails = await _persistanceDelegate.fetchEmailsWithFollowUp();

      if (emails.isNotEmpty) {
        logger.finest('Fetched ${emails.length} emails with follow up');
        for (final email in emails) {
          if (!email.followUpAt!.isToday) continue;

          await sendEmail(
            to: email.email,
            subject: email.subject,
            htmlBody: email.body,
          );
        }
      }

      return;
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }

  /// This method will add and email to the queue. it could be a email
  /// that failed to send or a scheduled email.
  Future<void> _addToEmailQueue({
    required Message message,
    required EmailStatus status,
  }) async {
    try {
      await _persistanceDelegate.insertEmailToQueue(
        email: message.recipients.first.toString(),
        subject: message.subject ?? '',
        body: message.html ?? '',
        status: status,
      );
      logger.finer('Email ${message.subject} added to the queue');
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }

  /// This method will mark an email as sent and added to the correct table
  /// on the database.
  Future<void> _markEmailAsSent({
    required Message message,
    int? followUpDays,
  }) async {
    try {
      await _persistanceDelegate.insertEmailSent(
        email: message.recipients.first.toString(),
        subject: message.subject ?? '',
        body: message.html ?? '',
        followUpDays: followUpDays,
      );
      logger.finer('Email sent to ${message.recipients.first}');
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }

  /// This method will delete a email in the queue table.
  Future<void> deleteEmailInQueue(int id) async {
    try {
      await _persistanceDelegate.deleteEmailsInQueue(id);
      logger.finer('Email with id: $id, deleted from queue');
      return;
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }
}
