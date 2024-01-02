// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmailImpl _$$EmailImplFromJson(Map<String, dynamic> json) => _$EmailImpl(
      id: json['id'] as int,
      email: json['email'] as String,
      subject: json['subject'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: $enumDecode(_$EmailStatusEnumMap, json['status']),
      logoUuid: json['logoUuid'] as String,
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      followUpAt: json['followUpAt'] == null
          ? null
          : DateTime.parse(json['followUpAt'] as String),
      readOn: json['readOn'] == null
          ? null
          : DateTime.parse(json['readOn'] as String),
    );

Map<String, dynamic> _$$EmailImplToJson(_$EmailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'subject': instance.subject,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$EmailStatusEnumMap[instance.status]!,
      'logoUuid': instance.logoUuid,
      'sentAt': instance.sentAt?.toIso8601String(),
      'followUpAt': instance.followUpAt?.toIso8601String(),
      'readOn': instance.readOn?.toIso8601String(),
    };

const _$EmailStatusEnumMap = {
  EmailStatus.notSent: 'notSent',
  EmailStatus.sent: 'sent',
  EmailStatus.queued: 'queued',
  EmailStatus.failed: 'failed',
  EmailStatus.read: 'read',
};
