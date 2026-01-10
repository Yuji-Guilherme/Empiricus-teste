import 'package:json_annotation/json_annotation.dart';
import 'author_model.dart';
import 'feature_model.dart';

part 'article_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ArticleModel {
  final ArticleIdentifier identifier;

  final String name;
  final String shortDescription;
  final String description;
  final String imageLarge;
  final String imageSmall;

  final List<AuthorModel> authors;
  final List<FeatureModel> features;

  const ArticleModel({
    required this.identifier,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.imageLarge,
    required this.imageSmall,
    this.authors = const [],
    this.features = const [],
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}

@JsonSerializable()
class ArticleIdentifier {
  final String slug;

  const ArticleIdentifier({required this.slug});

  factory ArticleIdentifier.fromJson(Map<String, dynamic> json) =>
      _$ArticleIdentifierFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleIdentifierToJson(this);
}
