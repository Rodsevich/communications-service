// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Email _$EmailFromJson(Map<String, dynamic> json) {
  return _Email.fromJson(json);
}

/// @nodoc
mixin _$Email {
  /// The id of the email
  int get id => throw _privateConstructorUsedError;

  /// The email address of the recipient
  String get email => throw _privateConstructorUsedError;

  /// The subject of the email
  String get subject => throw _privateConstructorUsedError;

  /// The body of the email, mostly a HTML string
  String get body => throw _privateConstructorUsedError;

  /// The date and time the email was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// The status of the email
  EmailStatus get status => throw _privateConstructorUsedError;

  /// The date and time the email was sent or scheduled
  DateTime? get sentAt => throw _privateConstructorUsedError;

  /// This is the value for follow up emails, it will be the days to wait
  /// to send the email
  DateTime? get followUpAt => throw _privateConstructorUsedError;

  /// The date on which the email was read by the recipient.
  DateTime? get readOn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmailCopyWith<Email> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailCopyWith<$Res> {
  factory $EmailCopyWith(Email value, $Res Function(Email) then) =
      _$EmailCopyWithImpl<$Res, Email>;
  @useResult
  $Res call(
      {int id,
      String email,
      String subject,
      String body,
      DateTime createdAt,
      EmailStatus status,
      DateTime? sentAt,
      DateTime? followUpAt,
      DateTime? readOn});
}

/// @nodoc
class _$EmailCopyWithImpl<$Res, $Val extends Email>
    implements $EmailCopyWith<$Res> {
  _$EmailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? subject = null,
    Object? body = null,
    Object? createdAt = null,
    Object? status = null,
    Object? sentAt = freezed,
    Object? followUpAt = freezed,
    Object? readOn = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EmailStatus,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      followUpAt: freezed == followUpAt
          ? _value.followUpAt
          : followUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readOn: freezed == readOn
          ? _value.readOn
          : readOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailImplCopyWith<$Res> implements $EmailCopyWith<$Res> {
  factory _$$EmailImplCopyWith(
          _$EmailImpl value, $Res Function(_$EmailImpl) then) =
      __$$EmailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String email,
      String subject,
      String body,
      DateTime createdAt,
      EmailStatus status,
      DateTime? sentAt,
      DateTime? followUpAt,
      DateTime? readOn});
}

/// @nodoc
class __$$EmailImplCopyWithImpl<$Res>
    extends _$EmailCopyWithImpl<$Res, _$EmailImpl>
    implements _$$EmailImplCopyWith<$Res> {
  __$$EmailImplCopyWithImpl(
      _$EmailImpl _value, $Res Function(_$EmailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? subject = null,
    Object? body = null,
    Object? createdAt = null,
    Object? status = null,
    Object? sentAt = freezed,
    Object? followUpAt = freezed,
    Object? readOn = freezed,
  }) {
    return _then(_$EmailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EmailStatus,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      followUpAt: freezed == followUpAt
          ? _value.followUpAt
          : followUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readOn: freezed == readOn
          ? _value.readOn
          : readOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailImpl extends _Email {
  const _$EmailImpl(
      {required this.id,
      required this.email,
      required this.subject,
      required this.body,
      required this.createdAt,
      required this.status,
      this.sentAt,
      this.followUpAt,
      this.readOn})
      : super._();

  factory _$EmailImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailImplFromJson(json);

  /// The id of the email
  @override
  final int id;

  /// The email address of the recipient
  @override
  final String email;

  /// The subject of the email
  @override
  final String subject;

  /// The body of the email, mostly a HTML string
  @override
  final String body;

  /// The date and time the email was created
  @override
  final DateTime createdAt;

  /// The status of the email
  @override
  final EmailStatus status;

  /// The date and time the email was sent or scheduled
  @override
  final DateTime? sentAt;

  /// This is the value for follow up emails, it will be the days to wait
  /// to send the email
  @override
  final DateTime? followUpAt;

  /// The date on which the email was read by the recipient.
  @override
  final DateTime? readOn;

  @override
  String toString() {
    return 'Email(id: $id, email: $email, subject: $subject, body: $body, createdAt: $createdAt, status: $status, sentAt: $sentAt, followUpAt: $followUpAt, readOn: $readOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.followUpAt, followUpAt) ||
                other.followUpAt == followUpAt) &&
            (identical(other.readOn, readOn) || other.readOn == readOn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, subject, body,
      createdAt, status, sentAt, followUpAt, readOn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailImplCopyWith<_$EmailImpl> get copyWith =>
      __$$EmailImplCopyWithImpl<_$EmailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailImplToJson(
      this,
    );
  }
}

abstract class _Email extends Email {
  const factory _Email(
      {required final int id,
      required final String email,
      required final String subject,
      required final String body,
      required final DateTime createdAt,
      required final EmailStatus status,
      final DateTime? sentAt,
      final DateTime? followUpAt,
      final DateTime? readOn}) = _$EmailImpl;
  const _Email._() : super._();

  factory _Email.fromJson(Map<String, dynamic> json) = _$EmailImpl.fromJson;

  @override

  /// The id of the email
  int get id;
  @override

  /// The email address of the recipient
  String get email;
  @override

  /// The subject of the email
  String get subject;
  @override

  /// The body of the email, mostly a HTML string
  String get body;
  @override

  /// The date and time the email was created
  DateTime get createdAt;
  @override

  /// The status of the email
  EmailStatus get status;
  @override

  /// The date and time the email was sent or scheduled
  DateTime? get sentAt;
  @override

  /// This is the value for follow up emails, it will be the days to wait
  /// to send the email
  DateTime? get followUpAt;
  @override

  /// The date on which the email was read by the recipient.
  DateTime? get readOn;
  @override
  @JsonKey(ignore: true)
  _$$EmailImplCopyWith<_$EmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
