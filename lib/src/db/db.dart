import 'package:mysql1/mysql1.dart';
import 'package:nidus_smpt/src/enums.dart';
import 'package:nidus_smpt/src/models/email/email.dart';

/// {@template database}
/// [Database] class handles all the query's to the database
/// {@endtemplate}
class Database {
  /// {@macro database}
  Database(this.connection);

  /// The connection to the database
  late final MySqlConnection connection;

  /// This method allows the creation of the tables in the database
  /// if they don't exist as a fixture.Only used once at the creation of the db.
  Future<void> initialFixture(MySqlConnection connection) async {
    try {
      await connection.query(
        '''
        CREATE TABLE IF NOT EXISTS EmailsQueue (
          id INT NOT NULL AUTO_INCREMENT,
          email VARCHAR(255) NOT NULL,
          subject VARCHAR(255) NOT NULL,
          body TEXT NOT NULL,
          createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
          sentAt DATETIME,
          status ENUM('sent', 'notSent', 'queued') NOT NULL DEFAULT 'queued',
          PRIMARY KEY (id),
          UNIQUE KEY (email)
        );

        CREATE TABLE IF NOT EXISTS EmailSent (
          id INT NOT NULL AUTO_INCREMENT,
          email VARCHAR(255) NOT NULL,
          subject VARCHAR(255) NOT NULL,
          body TEXT NOT NULL,
          sentAt DATETIME,
          readAt DATETIME,
          status ENUM('sent', 'notSent', 'queued') NOT NULL DEFAULT 'queued',
          created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (id),
          UNIQUE KEY (email)
        );
      ''',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method allows the insertion of an email to the queue.
  Future<void> insertEmailToQueue({
    required List<String> emails,
    required String subject,
    required String body,
    required EmailStatus status,
    DateTime? sentAt,
  }) async {
    try {
      for (final email in emails) {
        await connection.query(
          '''
        INSERT INTO EmailsQueue (email, subject, body, sentAt, status)
        VALUES (?, ?, ?, ?, ?)
      ''',
          [
            email,
            subject,
            body,
            sentAt,
            status.index,
          ],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// This method allows the insertion of an email to the sent table.
  Future<void> insertEmailSent({
    required List<String> emails,
    required String subject,
    required String body,
  }) async {
    try {
      for (final email in emails) {
        await connection.query(
          '''
        INSERT INTO EmailSent (email, subject, body, sentAt, status)
        VALUES (?, ?, ?, ?, ?)
        ''',
          [email, subject, body, DateTime.now(), 0],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// This method allows the update of an email to the sent table when the email
  /// has been read.
  Future<void> updateEmailAsRead(
    String email,
  ) async {
    try {
      await connection.query(
        '''
        UPDATE EmailSent
        SET readAt = NOW()
        WHERE email = ?;
      ''',
        [email],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method fetch all the emails in the queue. This emails can be 
  /// failures or scheduled emails.
  Future<List<Email>> fetchEmailsInQueue() async {
    try {
      final result = await connection.query(
        '''
      SELECT * FROM EmailsQueue;
      ''',
      );

      return result.map((e) => Email.fromJson(e.fields)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// This method deletes an email from the queue. Mostly once the email has
  /// been sent.
  Future<void> deleteEmailsInQueue(int id) async {
    try {
      await connection.query(
        '''
        DELETE FROM EmailsQueue
        WHERE id = ?;
      ''',
        [id],
      );
    } catch (e) {
      rethrow;
    }
  }
}
