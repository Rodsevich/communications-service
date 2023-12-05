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
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      status: $enumDecode(_$EmailStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$EmailImplToJson(_$EmailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'subject': instance.subject,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
      'status': _$EmailStatusEnumMap[instance.status]!,
    };

const _$EmailStatusEnumMap = {
  EmailStatus.sent: 'sent',
  EmailStatus.notSent: 'notSent',
  EmailStatus.queued: 'queued',
};
