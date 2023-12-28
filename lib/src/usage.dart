import 'dart:io';

import 'package:communication_service/communication_service.dart';
import 'package:communication_service/src/delegates/persistance/strategy/postgres_strategy.dart';
import 'package:logging/logging.dart';

void main() async {
  String message;
  Logger.root.onRecord.listen(
    (record) {
      var start = '\x1b[90m';
      const end = '\x1b[0m';
      const white = '\x1b[37m';

      switch (record.level.name) {
        case 'INFO':
          start = '\x1b[37m';
          break;
        case 'FINE':
          start = '\x1B[32m';
          break;
        case 'FINER':
          start = '\x1B[34m';
          break;
        case 'FINEST':
          start = '\x1B[36m';
          break;
        case 'SEVERE':
          start = '\x1b[103m\x1b[31m';
          break;
        case 'SHOUT':
          start = '\x1b[41m\x1b[93m';
          break;
      }

      message =
          '$white$end$start [${record.level.name}]: ${record.message} $end';

      if (record.error != null) {
        message += '\n${record.error}';
        if (record.stackTrace != null) {
          message += '\n${record.stackTrace}';
        }
      }
    },
  );

  // TODO(anyone): modificar los datos de la db ya que esta
  // no contiene las tablas requeridas para el mailer
  final smpt = CommunicationService(
    persistanceDelegate: PostgresStrategy(
      host: 'alcanza-qa.cd2usnwrufvg.us-east-2.rds.amazonaws.com',
      databaseName: 'defaultdb',
      userName: 'postgresadmin',
      dbPassword: '1Tzb7l18FSBEELjn',
      port: 5432,
    ),
    email: 'noreply@alcanza.com.do',
    displayName: 'noreply@alcanza.com.do',
    password: 'AccesoNuevo**2023',
    serverProvider: ServerProvider.outlook,
  );

  await smpt.setUp();

  await smpt.sendEmail(
    to: 'ficettiesteban@gmail.com',
    subject: 'No se',
    htmlBody: '<!DOCTYPE html><html><head><title>Your Page Title</title></head><body><h1>Hello, World!</h1></body</html>',
  );

  exit(0);
}
