// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      json['id'] as int,
      json['name'] as String,
      json['phone_number'] as String,
      json['role_name'] as String,
      json['has_already_read'] as bool?,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
      'role_name': instance.roleName,
      'has_already_read': instance.hasAlreadyBeenRead,
    };
