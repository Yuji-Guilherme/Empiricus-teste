import 'package:json_annotation/json_annotation.dart';

part 'author_model.g.dart';

@JsonSerializable()
class AuthorModel {
  final String name;
  final String? photoSmallUrl;
  final String? photoLargeUrl;

  final String? description;

  const AuthorModel({
    required this.name,
    this.photoSmallUrl,
    this.photoLargeUrl,
    this.description,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}
