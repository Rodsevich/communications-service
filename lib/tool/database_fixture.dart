import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

void main(List<String> args) async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  try {
    final connection = await Connection.open(
      Endpoint(
        host: env['DATABASE_HOST'] ?? 'localhost',
        database: env['DATABASE_NAME'] ?? 'default',
        username: env['DATABASE_USER'] ?? 'postgres',
        password: env['DATABASE_PASSWORD'] ?? 'postgres',
        port: int.parse(env['DATABASE_PORT'] ?? '5432'),
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
      ),
    );


    await connection.close();

    print('Success');
  } catch (e) {
    throw e;
  }

  exit(0);
}
