import 'package:communication_service/src/db/db.dart';
import 'package:communication_service/src/delegates/persistance/persistance_delegate.dart';
import 'package:communication_service/src/enums.dart';
import 'package:communication_service/src/extensions/extensions.dart';
import 'package:communication_service/src/models/email/email.dart';
import 'package:enough_mail/mime.dart';
import 'package:logging/src/logger.dart';

///
class PostgresStrategy extends PersistanceDelegate {
  ///
  PostgresStrategy({
    required String host,
    required String databaseName,
    required String userName,
    required String dbPassword,
    required int port,
  })  : _host = host,
        _databaseName = databaseName,
        _userName = userName,
        _dbPassword = dbPassword,
        _port = port,
        super();

  @override
  Logger get logger => Logger('PostgresStrategy');

  late final Database _database;

  final String _host;

  final String _databaseName;

  final String _userName;

  final String _dbPassword;

  final int _port;

  @override
  Future<void> setUp() async {
    _database = Database();

    await Database.initialConnection(
      host: _host,
      databaseName: _databaseName,
      userName: _userName,
      password: _dbPassword,
      port: _port,
    );
  }

  @override
  Future<List<Email>> fetchEmailsInDateRange(DateTime date) async {
    try {
      final emails = await _database.fetchEmailsInDateRange(date);
      return emails;
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }

  @override
  Future<void> resendEmailsInQueue() async {
    try {
      final emails = await _database.fetchEmailsInQueue();

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

  @override
  Future<void> sendEmailsWithFollowUp() async {
    try {
      final emails = await _database.fetchEmailsWithFollowUp();

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

  @override
  Future<void> addToEmailQueue({
    required MimeMessage message,
    required EmailStatus status,
  }) async {
    try {
      await _database.insertEmailToQueue(
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

  @override
  Future<void> markEmailAsSent({
    required MimeMessage message,
    int? followUpDays,
  }) async {
    try {
      await _database.insertEmailSent(
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

  @override
  Future<void> deleteEmailInQueue(int id) async {
    try {
      await _database.deleteEmailsInQueue(id);
      logger.finer('Email with id: $id, deleted from queue');
      return;
    } catch (e, st) {
      logger.severe('We should handle', e, st);
      rethrow;
    }
  }
}
