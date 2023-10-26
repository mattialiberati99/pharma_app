// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..email = json['email'] as String?
  ..password = json['password'] as String?
  ..apiToken = json['apiToken'] as String?
  ..deviceToken = json['deviceToken'] as String?
  ..phone = json['phone'] as String?
  ..address = json['address'] as String?
  ..bio = json['bio'] as String?
  ..created = json['created'] as bool
  ..manager = json['manager'] as bool
  ..auth = json['auth'] as bool?
  ..fattura = json['fattura'] as bool?
  ..notif = json['notif'] as bool?
  ..localiz = json['localiz'] as bool?
  ..userInvitationCode = json['userInvitationCode'] as String?
  ..verified = json['verified'] == null
      ? null
      : DateTime.parse(json['verified'] as String)
  ..imagePath = json['imagePath'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'apiToken': instance.apiToken,
      'deviceToken': instance.deviceToken,
      'phone': instance.phone,
      'address': instance.address,
      'bio': instance.bio,
      'created': instance.created,
      'manager': instance.manager,
      'auth': instance.auth,
      'fattura': instance.fattura,
      'notif': instance.notif,
      'localiz': instance.localiz,
      'userInvitationCode': instance.userInvitationCode,
      'verified': instance.verified?.toIso8601String(),
      'imagePath': instance.imagePath,
    };
