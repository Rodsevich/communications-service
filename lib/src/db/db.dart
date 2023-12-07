import 'package:nidus_smpt/src/enums.dart';
import 'package:nidus_smpt/src/generated/prisma/prisma_client.dart';

/// {@template database}
/// [Database] class handles all the execute's to the database
/// {@endtemplate}
class Database {
  /// {@macro database}
  Database(this.prismaClient);

  /// The connection to the database
  late final PrismaClient prismaClient;

  /// This method allows the insertion of an email to the queue.
  Future<void> insertEmailToQueue({
    required String email,
    required String subject,
    required String body,
    required EmailStatus status,
    DateTime? sentAt,
  }) async {
    try {
      await prismaClient.emailqueue.create(
        data: EmailqueueCreateInput(
          to: email,
          subject: subject,
          body: body,
          sentat: sentAt,
          status: status.index,
        ),
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
      await prismaClient.emailsent.create(
        data: EmailsentCreateInput(
          to: email,
          subject: subject,
          body: body,
          sentat: DateTime.now(),
          status: EmailStatus.sent.index,
        ),
      );
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
      await prismaClient.emailsent.update(
        data: EmailsentUpdateInput(
          status: IntFieldUpdateOperationsInput(
            set: EmailStatus.read.index,
          ),
        ),
        where: EmailsentWhereUniqueInput(
          to: StringFilter(
            equals: email,
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This method fetch all the emails in the queue. This emails can be
  /// failures or scheduled emails.
  Future<List<Emailqueue>> fetchEmailsInQueue() async {
    try {
      final emailsInQueue = await prismaClient.emailqueue.findMany(
        where: const EmailqueueWhereInput(
          // the default value is null for [DateTimeNullableFilter]
          sentat: DateTimeNullableFilter(),
        ),
      );

      return emailsInQueue.toList();
    } catch (e) {
      rethrow;
    }
  }

  /// This method deletes an email from the queue. Mostly once the email has
  /// been sent.
  Future<void> deleteEmailsInQueue(int id) async {
    try {
      await prismaClient.emailqueue.delete(
        where: EmailqueueWhereUniqueInput(
          id: id,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
