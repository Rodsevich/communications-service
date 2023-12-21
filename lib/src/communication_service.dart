import 'dart:async';
import 'dart:io';

import 'package:communication_service/nidus_smtp.dart';
import 'package:communication_service/src/delegates/persistance/persistance_delegate.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail/mime.dart';
import 'package:logging/logging.dart';
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
    required ServerProvider variant,
  }) : _persistanceDelegate = persistanceDelegate {
    try {
      _persistanceDelegate.setUp();

      logger.finest(
        'Communication Service instance created',
      );
    } catch (e, st) {
      logger.shout(
        'Error while creating Communication Service instance',
        e,
        st,
      );
      rethrow;
    }

    switch (variant) {
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

  Future<void> h(String email, String password) async {
    final config = await Discover.discover(email);

    if (config == null) {
      print('Unable to auto-discover settings for $email');
      return;
    }

    print('connecting to ${config.displayName}.');

    final account = MailAccount.fromDiscoveredSettings(
      name: name,
      email: email,
      password: password,
      config: config,
      userName: userName,
    );
  }

  /// This is the main connection to the SMPT to use for sending emails.
  late final SmtpServer _smtpServer;

  /// This is the address to use for sending emails.
  late final Address _from;

  late final PersistanceDelegate _persistanceDelegate;

  ///
  PersistanceDelegate get persistanceDelegate => _persistanceDelegate;

  /// This is the logger for this class.
  final logger = Logger('CommunicarionService');

  /// This method sends an email to the recipient.
  Future<void> sendEmail({
    required MailAddress to,
    required String subject,
    required String htmlBody,
    DateTime? sentAt,
    int? followUpDays,
  }) async {
    logger.info('Sending email to $to');

    final builder = MessageBuilder()
      ..from = from
      ..to = [to]
      ..addMultipartAlternative(
        htmlText: htmlBody,
      );
    final message = builder.buildMimeMessage();

    if (sentAt != null) {
      await persistanceDelegate.addToEmailQueue(
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

      await persistanceDelegate.markEmailAsSent(
        message: message,
        followUpDays: followUpDays,
      );

      logger.fine('Email sent successfully to $to');
    } on Exception catch (e, st) {
      logger.severe('We should handle this error', e, st);
      await persistanceDelegate.addToEmailQueue(
        message: message,
        status: EmailStatus.failed,
      );
      rethrow;
    }
  }
}
