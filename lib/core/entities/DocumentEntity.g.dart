// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DocumentEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentEntity _$DocumentEntityFromJson(Map<String, dynamic> json) =>
    DocumentEntity(
      json['id'] as int,
      json['file_name'] as String,
      DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DocumentEntityToJson(DocumentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_name': instance.fileName,
      'created_at': instance.createdAt.toIso8601String(),
    };
