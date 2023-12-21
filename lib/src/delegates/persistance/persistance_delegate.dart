import 'dart:async';

import 'package:communication_service/communication_service.dart';
import 'package:communication_service/src/models/email/email.dart';
import 'package:logging/logging.dart';

/// This abstract class defines a delegate responsible for persisting
/// and retrieving email data. It provides a set of methods to
/// manage emails within a queue and a sent table, enabling
/// persistent storage and retrieval of email information.
///
/// Implementation:
///
/// Concrete subclasses must implement the methods defined in this
/// class to provide specific persistence functionality,
/// such as using a database, file storage, or other suitable mechanisms.
abstract class PersistanceDelegate {
  /// This is the logger for this class.
  final logger = Logger('PersistanceDelegate');

  /// Performs any necessary setup tasks for the persistence delegate.
  FutureOr<void> setUp();

  /// Allows the insertion of an email to the queue.
  FutureOr<void> insertEmailToQueue({
    required String email,
    required String subject,
    required String body,
    required EmailStatus status,
    DateTime? sentAt,
  });

  /// Allows the insertion of an email to the sent table.
  FutureOr<void> insertEmailSent({
    required String email,
    required String subject,
    required String body,
    int? followUpDays,
  });

  /// Allows the update of an email to the sent table when the email
  /// has been read.
  FutureOr<void> updateEmailAsRead(String id);

  /// Fetch all the emails in the queue. This emails can be
  /// failures or scheduled emails.
  FutureOr<List<Email>> fetchEmailsInQueue();

  /// Deletes an email from the queue. Mostly once the email has
  /// been sent.
  FutureOr<void> deleteEmailsInQueue(int id);

  /// Fetch a list of emails in a date range.
  FutureOr<List<Email>> fetchEmailsInDateRange(DateTime datetime);

  /// Fetch a list of emails with followUp value.
  FutureOr<List<Email>> fetchEmailsWithFollowUp();
}
