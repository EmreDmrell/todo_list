import 'package:json_annotation/json_annotation.dart';


part 'duty_type.g.dart';


@JsonSerializable()
class DutyType {
  final int? id;
  final String? name;

  DutyType(this.id, {required this.name});


  factory DutyType.fromJson(Map<String, dynamic> json) => _$DutyTypeFromJson(json);


  Map<String, dynamic> toJson() => _$DutyTypeToJson(this);

}
