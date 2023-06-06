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
      : Media.fromJSON(json['image'] as Map<String, dynamic>)
  ..description = json['description'] as String?
  ..ingredients = json['ingredients'] as String?
  ..weight = json['weight'] as String?
  ..unit = json['unit'] as String?
  ..packageItemsCount = json['packageItemsCount'] as String?
  ..featured = json['featured'] as bool?
  ..deliverable = json['deliverable'] as bool?
  ..rate = (json['rate'] as num?)?.toDouble()
  ..rateCount = json['rateCount'] as int?
  ..arrivo = json['arrivo'] as String?;

Map<String, dynamic> _$FarmacoToJson(Farmaco instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'iva': instance.iva,
      'image': instance.image,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'weight': instance.weight,
      'unit': instance.unit,
      'packageItemsCount': instance.packageItemsCount,
      'featured': instance.featured,
      'deliverable': instance.deliverable,
      'rate': instance.rate,
      'rateCount': instance.rateCount,
      'arrivo': instance.arrivo,
      'gallery': instance.gallery,
    };
