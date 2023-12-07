import 'dart:io';

import 'package:postgres/postgres.dart';

void main(List<String> args) async {
  try {
    final connection = await Connection.open(
      Endpoint(
        host: 'alcanza-qa.cd2usnwrufvg.us-east-2.rds.amazonaws.com',
        database: 'db-1.10.1',
        username: 'postgresadmin',
        password: '1Tzb7l18FSBEELjn',
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
      ),
    );

    await connection.execute('''
   CREATE TABLE IF NOT EXISTS ${args[0]}.EmailQueue (
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
   CREATE TABLE IF NOT EXISTS ${args[0]}.EmailSent (
  id SERIAL PRIMARY KEY,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sentAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "to" VARCHAR(255) NOT NULL,
  subject VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  status INT NOT NULL DEFAULT 0
);
  ''');

    await connection.close();

    print('Success');
  } catch (e) {
    throw e;
  }

  exit(0);
}
