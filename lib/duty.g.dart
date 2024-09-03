// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Duty _$DutyFromJson(Map<String, dynamic> json) => Duty(
      name: json['name'] as String,
      isCompleted: json['situation'] == 1 ? true : false ,
      typeId: json['typeId'],
    )..id = json['id'] as int;

Map<String, dynamic> _$DutyToJson(Duty instance) => <String, dynamic>{
      'name': instance.name,
      'situation': instance.isCompleted ? 1 : 0,
      'typeId': instance.typeId,
    };
