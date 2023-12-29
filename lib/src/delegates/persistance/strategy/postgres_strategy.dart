// ignore_for_file: lines_longer_than_80_chars

import 'package:communication_service/src/delegates/persistance/persistance_delegate.dart';
import 'package:communication_service/src/enums.dart';
import 'package:communication_service/src/models/email/email.dart';
import 'package:logging/src/logger.dart';
import 'package:postgres/postgres.dart';

/// {@template PostgresStrategy}
/// Concrete implementation of [PersistanceDelegate] using a PostgreSQL database.
/// {@endtemplate}
class PostgresStrategy implements PersistanceDelegate {
  /// {@macro PostgresStrategy}
  PostgresStrategy({
    /// The hostname or IP address of the PostgreSQL server.
    required String host,

    /// The name of the database to connect to.
    required String databaseName,

    /// The username for authentication.
    required String userName,

    /// The password for authentication.
    required String dbPassword,

    /// The port number on which the PostgreSQL server is listening.
    required int port,

    /// The SSL mode to use for the connection
    SslMode? sslMode,
  })  : _host = host,
        _databaseName = databaseName,
        _userName = userName,
        _dbPassword = dbPassword,
        _port = port,
        _sslMode = sslMode,
        super();

  @override
  Logger get logger => Logger('PostgresStrategy');

  final String _host;

  final String _databaseName;

  final String _userName;

  final String _dbPassword;

  final int _port;

  final SslMode? _sslMode;

  /// The connection to the database
  late final Connection connection;

  /// Initializes the database with the necessary tables for email persistence.
  ///
  /// [schema]: The name of the schema where the tables should be created.
  Future<void> initialFixture(String schema) async {
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $schema.EmailQueue (
      id SERIAL PRIMARY KEY,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      sentAt TIMESTAMP,
      "to" VARCHAR(255) NOT NULL,
      subject VARCHAR(255) NOT NULL,
      body TEXT NOT NULL,
      status INT NOT NULL DEFAULT 0,
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
      status INT NOT NULL DEFAULT 0,
      followUpAt TIMESTAMP,
    );
  ''');

    return;
  }

  @override
  Future<void> setUp() async {
    connection = await Connection.open(
      Endpoint(
        host: _host,
        database: _databaseName,
        username: _userName,
        password: _dbPassword,
        port: _port,
      ),
      settings: _sslMode != null
          ? ConnectionSettings(
              sslMode: _sslMode,
            )
          : null,
    );
  }

  @override
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
          'INSERT INTO emailqueue ("to", subject, body, sentat, status) VALUES (@to, @subject, @body, @sentat, @status',
        ),
        parameters: {
          'to': email,
          'subject': subject,
          'body': body,
          'sentat': sentAt,
          'status': status.index,
        },
      );
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Email> insertEmailSent({
    required String email,
    required String subject,
    required String body,
    int? followUpDays,
  }) async {
    try {
      final query = await connection.execute(
        Sql.named(
          'INSERT INTO emailsent ("to", subject, body, sentat, status, followupat) VALUES (@to, @subject, @body, @sentat, @status, @followupat) RETURNING *',
        ),
        parameters: {
          'to': email,
          'subject': subject,
          'body': body,
          'sentat': DateTime.now(),
          'status': EmailStatus.sent.index,
          'followupat': followUpDays != null
              ? DateTime.now().add(Duration(days: followUpDays))
              : null,
        },
      );

      final emailSent = query.map(
        (row) {
          return Email(
            id: row[0] as int? ?? 0,
            createdAt: row[1] as DateTime? ?? DateTime.now(),
            sentAt: row[2] as DateTime?,
            email: row[3] as String? ?? '-',
            subject: row[4] as String? ?? '-',
            body: row[5] as String? ?? '-',
            status: EmailStatus.values[row[6] as int? ?? 0],
          );
        },
      ).first;

      return emailSent;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateEmailAsRead(
    String id,
  ) async {
    try {
      await connection.execute(
        Sql.named(
          'UPDATE emailsent '
          'SET status = @status, readOn = @readOn '
          'WHERE id = @id',
        ),
        parameters: {
          'id': id,
          'status': EmailStatus.read.index,
          'readOn': DateTime.now(),
        },
      );
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Email>> fetchEmailsInQueue() async {
    try {
      final query = await connection.execute(
        'SELECT * FROM emailqueue WHERE sentat IS NULL',
      );

      final results = query.map(
        (row) {
          return Email(
            id: row[0] as int? ?? 0,
            createdAt: row[1] as DateTime? ?? DateTime.now(),
            sentAt: row[2] as DateTime?,
            email: row[3] as String? ?? '-',
            subject: row[4] as String? ?? '-',
            body: row[5] as String? ?? '-',
            status: EmailStatus.values[row[6] as int? ?? 0],
          );
        },
      ).toList();

      return results;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEmailsInQueue(int id) async {
    try {
      await connection.execute(
        Sql.named('DELETE FROM emailqueue WHERE id = @id'),
        parameters: {
          'id': id,
        },
      );
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Email>> fetchEmailsInDateRange(DateTime datetime) async {
    try {
      final query = await connection.execute(
        Sql.named(
          '''
              SELECT * FROM emailsent 
              WHERE sentat <= @datetime 
              AND status != @readStatus
              ''',
        ),
        parameters: {
          'datetime': datetime,
          'readStatus': EmailStatus.read.index,
        },
      );

      final results = query.map(
        (row) {
          return Email(
            id: row[0] as int? ?? 0,
            createdAt: row[1] as DateTime? ?? DateTime.now(),
            sentAt: row[2] as DateTime? ?? DateTime.now(),
            email: row[3] as String? ?? '-',
            subject: row[4] as String? ?? '-',
            body: row[5] as String? ?? '-',
            status: EmailStatus.values[row[6] as int? ?? 0],
          );
        },
      ).toList();

      return results;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Email>> fetchEmailsWithFollowUp() async {
    try {
      final query = await connection.execute(
        Sql.named(
          '''
              SELECT * FROM emailsent 
                WHERE followupat IS NOT NULL
              ''',
        ),
      );

      final results = query.map(
        (row) {
          return Email(
            id: row[0] as int? ?? 0,
            createdAt: row[1] as DateTime? ?? DateTime.now(),
            sentAt: row[2] as DateTime? ?? DateTime.now(),
            email: row[3] as String? ?? '-',
            subject: row[4] as String? ?? '-',
            body: row[5] as String? ?? '-',
            status: EmailStatus.values[row[6] as int? ?? 0],
            followUpAt: row[7] as DateTime? ?? DateTime.now(),
          );
        },
      ).toList();

      return results;
    } catch (e) {
      rethrow;
    }
  }
}
