import 'package:mysql1/mysql1.dart';

/// {@template db_connection}
/// [DbConnection] class handles the connection to the database
/// {@endtemplate}
class DbConnection {
  /// {@macro db_connection}
  DbConnection({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.database,
  });

  /// The host of the database
  final String host;

  /// The port of the database
  final int port;

  /// The user of the database
  final String user;

  /// The password of the database
  final String password;

  /// The database name 
  final String database;

  /// This method allows the connection to the database and returns 
  /// a [MySqlConnection] instance for further use as a query.
  Future<MySqlConnection> connect() async {
    try {
      return MySqlConnection.connect(
        ConnectionSettings(
          host: host,
          port: port,
          user: user,
          password: password,
          db: database,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method allows the disconnection from the database.
  static Future<void> disconnect(MySqlConnection connection) async {
    await connection.close();
  }
}
