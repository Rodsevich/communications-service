import 'package:nidus_smpt/src/enums.dart';
import 'package:postgres/postgres.dart';

/// {@template database}
/// [Database] class handles all the execute's to the database
/// {@endtemplate}
class Database {
  /// {@macro database}
  Database(this.connection);

  /// The connection to the database
  late final Connection connection;

  ///
  static Future<Connection> initialConnection({
    required String host,
    required String databaseName,
    required String userName,
    required String password,
    required int port,
    SslMode? sslMode,
  }) async {
    return Connection.open(
      Endpoint(
        host: host,
        database: databaseName,
        username: userName,
        password: password,
        port: port,
      ),
      settings: sslMode != null
          ? ConnectionSettings(
              sslMode: sslMode,
            )
          : null,
    );
  }

  ///
  Future<void> initialFixture(String schema) async {
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $schema.EmailQueue (
      id SERIAL PRIMARY KEY,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      sentAt TIMESTAMP,
      "to" VARCHAR(255) NOT NULL,
      subject VARCHAR(255) NOT NULL,
      body TEXT NOT NULL,
      status INT NOT NULL DEFAULT 0
    );
  ''');

    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $schema.EmailSent (
      id SERIAL PRIMARY KEY,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      sentAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "to" VARCHAR(255) NOT NULL,
      subject VARCHAR(255) NOT NULL,
      body TEXT NOT NULL,
      status INT NOT NULL DEFAULT 0
    );
  ''');
  }

  /// This method allows the insertion of an email to the queue.
  Future<void> insertEmailToQueue({
    required String email,
    required String subject,
    required String body,
    required EmailStatus status,
    DateTime? sentAt,
  }) async {
    try {
      await connection.execute(
        Sql.named(
          'INSERT INTO emailqueue ("to", subject, body, sentat, status) VALUES (@to, @subject, @body, @sentat, @status)',
        ),
        parameters: {
          'to': email,
          'subject': subject,
          'body': body,
          'sentat': sentAt,
          'status': status.index,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method allows the insertion of an email to the sent table.
  Future<void> insertEmailSent({
    required String email,
    required String subject,
    required String body,
  }) async {
    try {
      await connection.execute(
        Sql.named(
            'INSERT INTO emailsent ("to", subject, body, sentat, status) VALUES (@to, @subject, @body, @sentat, @status)'),
        parameters: {
          'to': email,
          'subject': subject,
          'body': body,
          'sentat': DateTime.now(),
          'status': EmailStatus.sent.index,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method allows the update of an email to the sent table when the email
  /// has been read.
  Future<void> updateEmailAsRead(
    String id,
  ) async {
    try {
      await connection.execute(
        Sql.named('UPDATE emailsent SET status = @status WHERE id = @id'),
        parameters: {
          'id': id,
          'status': EmailStatus.read.index,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method fetch all the emails in the queue. This emails can be
  /// failures or scheduled emails.
  Future<void> fetchEmailsInQueue() async {
    try {
      final query = await connection.execute(
        'SELECT * FROM emailqueue WHERE sentat IS NULL',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method deletes an email from the queue. Mostly once the email has
  /// been sent.
  Future<void> deleteEmailsInQueue(int id) async {
    try {
      await connection.execute(
        Sql.named('DELETE FROM emailqueue WHERE id = @id'),
        parameters: {
          'id': id,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
