// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCategory _$AppCategoryFromJson(Map<String, dynamic> json) => AppCategory()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..image = json['image'] == null
      ? null
      : Media.fromJson(json['image'] as Map<String, dynamic>)
  ..presentation = json['presentation'] == null
      ? null
      : Media.fromJson(json['presentation'] as Map<String, dynamic>)
  ..foods = (json['foods'] as List<dynamic>?)
      ?.map((e) => Farmaco.fromJson(e as Map<String, dynamic>))
      .toList()
  ..otherCategories = (json['otherCategories'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$AppCategoryToJson(AppCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'presentation': instance.presentation,
      'foods': instance.foods,
      'otherCategories': instance.otherCategories,
    };
