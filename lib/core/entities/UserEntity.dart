import 'package:json_annotation/json_annotation.dart';
part 'UserEntity.g.dart';

@JsonSerializable()
class UserEntity{
  int id;
  String name;
  @JsonKey(name: 'phone_number')
  String phoneNumber;
  @JsonKey(name: 'role_name')
  String roleName;
  @JsonKey(name: 'has_already_read')
  bool? hasAlreadyBeenRead;

  UserEntity(this.id, this.name, this.phoneNumber, this.roleName, this.hasAlreadyBeenRead);

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}