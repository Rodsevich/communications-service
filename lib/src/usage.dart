import 'package:logging/logging.dart';
import 'package:nidus_smpt/nidus_smpt.dart';
import 'package:nidus_smpt/src/db/db.dart';
import 'package:nidus_smpt/src/generated/prisma/prisma_client.dart';

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

  Database(PrismaClient());

  final smpt = NidusSmpt(
    email: 'noreply@alcanza.com.do',
    password: 'AccesoNuevo**2023',
    displayName: 'Alcanza',
    variant: SmptVariant.outlook,
  );

  await smpt.sendEmail(
    to: 'ficettiesteban@gmail.com',
    subject: 'testing smpt',
    htmlBody: 'Esta wea es un body',
  );
}

// model EmailQueue {
//   id        Int      @id @default(autoincrement())
//   createdAt DateTime @default(now())
//   sentAt    DateTime?
//   to        String
//   subject   String
//   body      String
//   status    Int     @default(0)
// }

// model EmailSent {
//   id        Int      @id @default(autoincrement())
//   createdAt DateTime @default(now())
//   sentAt    DateTime @default(now())
//   to        String
//   subject   String
//   body      String
//   status    Int     @default(0)
// }