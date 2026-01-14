import 'package:empiricus_test/features/articles/domain/entities/author_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author_model.g.dart';

@JsonSerializable()
class AuthorModel extends AuthorEntity {
  const AuthorModel({
    required super.name,
    super.photoSmallUrl,
    super.photoLargeUrl,
    super.description,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}
