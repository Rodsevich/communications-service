import 'dart:async';

import 'package:communication_service/nidus_smtp.dart';
import 'package:communication_service/src/models/email/email.dart';
import 'package:enough_mail/mime.dart';
import 'package:logging/logging.dart';

///
abstract class PersistanceDelegate {
  /// This is the logger for this class.
  final logger = Logger('PersistanceDelegate');

  ///
  FutureOr<void> setUp();

  /// This method will fetch all the emails in the queue and send them. it will
  /// avoid sending the emails with sentAt different than [DateTime.now()].
  Future<void> resendEmailsInQueue();

  /// This method will add and email to the queue. it could be a email
  /// that failed to send or a scheduled email.
  Future<void> addToEmailQueue({
    required MimeMessage message,
    required EmailStatus status,
  });

  /// This method will mark an email as sent and added to the correct table
  /// on the database.
  Future<void> markEmailAsSent({
    required MimeMessage message,
    int? followUpDays,
  });

  /// This method will delete a email in the queue table.
  Future<void> deleteEmailInQueue(int id);

  /// This method will fetch all emails is a range.
  Future<List<Email>> fetchEmailsInDateRange(DateTime date);

  ///
  Future<void> sendEmailsWithFollowUp();
}
