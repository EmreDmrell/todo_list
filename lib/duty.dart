import 'package:json_annotation/json_annotation.dart';

part 'duty.g.dart';

@JsonSerializable()
class Duty {
  late int id;
  late String name;
  late bool isCompleted;
  late int? typeId;

  Duty({required this.name, required this.isCompleted, required this.typeId});

  factory Duty.fromJson(Map<String, dynamic> json) => _$DutyFromJson(json);

  Map<String, dynamic> toJson() => _$DutyToJson(this);
}
