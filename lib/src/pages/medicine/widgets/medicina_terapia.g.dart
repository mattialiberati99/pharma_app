// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicina_terapia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicinaTerapia _$MedicinaTerapiaFromJson(Map<String, dynamic> json) =>
    MedicinaTerapia(
      Farmaco.fromJson(json['farmaco'] as Map<String, dynamic>),
      json['nomeTerapia'] as String,
      (json['giorni'] as List<dynamic>).map((e) => e as int).toList(),
      json['durata'] as String,
      json['quantita'] as String,
      json['orario'] as String,
    );

Map<String, dynamic> _$MedicinaTerapiaToJson(MedicinaTerapia instance) =>
    <String, dynamic>{
      'farmaco': instance.farmaco,
      'nomeTerapia': instance.nomeTerapia,
      'giorni': instance.giorni,
      'durata': instance.durata,
      'quantita': instance.quantita,
      'orario': instance.orario,
    };
