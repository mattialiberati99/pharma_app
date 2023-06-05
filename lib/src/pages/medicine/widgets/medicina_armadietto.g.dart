// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicina_armadietto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicinaArmadietto _$MedicinaArmadiettoFromJson(Map<String, dynamic> json) =>
    MedicinaArmadietto(
      Farmaco.fromJson(json['farmaco'] as Map<String, dynamic>),
      json['scadenza'] as String,
    );

Map<String, dynamic> _$MedicinaArmadiettoToJson(MedicinaArmadietto instance) =>
    <String, dynamic>{
      'farmaco': instance.farmaco,
      'scadenza': instance.scadenza,
    };
