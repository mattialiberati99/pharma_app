// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmaco.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Farmaco _$FarmacoFromJson(Map<String, dynamic> json) => Farmaco()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..discountPrice = (json['discountPrice'] as num?)?.toDouble()
  ..iva = (json['iva'] as num?)?.toDouble()
  ..image = json['image'] == null
      ? null
      : Media.fromJson(json['image'] as Map<String, dynamic>)
  ..description = json['description'] as String?
  ..foglietto = json['foglietto'] as String?
  ..ingredients = json['ingredients'] as String?
  ..weight = json['weight'] as String?
  ..unit = json['unit'] as String?
  ..packageItemsCount = json['packageItemsCount'] as String?
  ..featured = json['featured'] as bool?
  ..deliverable = json['deliverable'] as bool?
  ..farmacia = json['farmacia'] == null
      ? null
      : Shop.fromJSON(json['farmacia'] as Map<String, dynamic>)
  ..category = json['category'] == null
      ? null
      : AppCategory.fromJSON(json['category'] as Map<String, dynamic>)
  ..rate = (json['rate'] as num?)?.toDouble()
  ..rateCount = json['rateCount'] as int?
  ..arrivo = json['arrivo'] as String?
  ..gallery = (json['gallery'] as List<dynamic>?)
      ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$FarmacoToJson(Farmaco instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'iva': instance.iva,
      'image': instance.image,
      'description': instance.description,
      'foglietto': instance.foglietto,
      'ingredients': instance.ingredients,
      'weight': instance.weight,
      'unit': instance.unit,
      'packageItemsCount': instance.packageItemsCount,
      'featured': instance.featured,
      'deliverable': instance.deliverable,
      'farmacia': instance.farmacia,
      'category': instance.category,
      'rate': instance.rate,
      'rateCount': instance.rateCount,
      'arrivo': instance.arrivo,
      'gallery': instance.gallery,
    };
