// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..file_name = json['file_name'] as String?
  ..url = json['url'] as String?
  ..thumb = json['thumb'] as String?
  ..wide_thumb = json['wide_thumb'] as String?
  ..icon = json['icon'] as String?
  ..size = json['size'] as String?
  ..mime_type = json['mime_type'] as String?
  ..collection = json['collection'] as String?
  ..isVideo = json['isVideo'] as bool;

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.file_name,
      'url': instance.url,
      'thumb': instance.thumb,
      'wide_thumb': instance.wide_thumb,
      'icon': instance.icon,
      'size': instance.size,
      'mime_type': instance.mime_type,
      'collection': instance.collection,
      'isVideo': instance.isVideo,
    };
