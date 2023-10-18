// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicina_routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicinaRoutine _$MedicinaRoutineFromJson(Map<String, dynamic> json) =>
    MedicinaRoutine(
      Farmaco.fromJson(json['farmaco'] as Map<String, dynamic>),
      json['nomeRoutine'] as String,
      (json['giorni'] as List<dynamic>).map((e) => e as int).toList(),
      json['durata'] as String,
      json['quantita'] as String,
      json['orario'] as String,
    );

Map<String, dynamic> _$MedicinaRoutineToJson(MedicinaRoutine instance) =>
    <String, dynamic>{
      'farmaco': instance.farmaco,
      'nomeRoutine': instance.nomeRoutine,
      'giorni': instance.giorni,
      'durata': instance.durata,
      'quantita': instance.quantita,
      'orario': instance.orario,
    };
