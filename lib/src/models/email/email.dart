import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nidus_smpt/src/enums.dart';

part 'email.freezed.dart';
part 'email.g.dart';

@freezed
/// {@template email}
/// [Email] class is the model for the emails
/// {@endtemplate}
class Email with _$Email {

  /// {@macro email}
  const factory Email({
    /// The id of the email
    required int id,

    /// The email address of the recipient
    required String email,

    /// The subject of the email
    required String subject,

    /// The body of the email, mostly a HTML string
    required String body,

    /// The date and time the email was created
    required DateTime createdAt,

    /// The status of the email
    required EmailStatus status,

    /// The date and time the email was sent or scheduled
    DateTime? sentAt,
  }) = _Email;

  /// {@macro fromJson}
  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);

  const Email._();
}
