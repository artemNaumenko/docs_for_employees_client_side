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
      json['link'] as String?,
      json['has_already_read'] as bool?,
    );

Map<String, dynamic> _$DocumentEntityToJson(DocumentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_name': instance.fileName,
      'created_at': instance.createdAt.toIso8601String(),
      'link': instance.link,
      'has_already_read': instance.wasRead,
    };
