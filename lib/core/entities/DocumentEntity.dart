import 'package:json_annotation/json_annotation.dart';
part 'DocumentEntity.g.dart';

@JsonSerializable()
class DocumentEntity{
  final int id;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final String? link;

  DocumentEntity(this.id, this.fileName, this.createdAt, this.link);

  factory DocumentEntity.fromJson(Map<String, dynamic> json) => _$DocumentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentEntityToJson(this);
}