import 'dart:io';

import 'package:logging/logging.dart';
import 'package:nidus_smpt/nidus_smpt.dart';
import 'package:nidus_smpt/src/db/db.dart';

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

  final dbConn = await Database.initialConnection(
    host: '',
    databaseName: '',
    userName: '',
    password: '',
    port: 5432,
  );

  await Database(dbConn).initialFixture('public');

  final smpt = NidusSmpt(
    email: '',
    password: '',
    displayName: '',
    variant: SmptVariant.outlook,
    database: Database(dbConn),
  );

  // await smpt.sendEmail(
  //   to: 'ficettiesteban@gmail.com',
  //   subject: 'testing smpt',
  //   htmlBody: 'Esta wea es un body',
  // );

  await smpt.fetchEmailsInDateRange(DateTime.now());


  exit(0);
}
