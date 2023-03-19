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
  @JsonKey(name: 'has_already_read')
  final bool? wasRead;


  DocumentEntity(this.id, this.fileName, this.createdAt, this.link, this.wasRead);

  factory DocumentEntity.fromJson(Map<String, dynamic> json) => _$DocumentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentEntityToJson(this);
}