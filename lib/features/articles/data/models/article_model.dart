import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'author_model.dart';
import 'feature_model.dart';

part 'article_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ArticleModel extends ArticleEntity {
  @JsonKey(name: 'identifier')
  final ArticleIdentifier identifierModel;

  @override
  final List<AuthorModel> authors;
  @override
  final List<FeatureModel> features;

  ArticleModel({
    required this.identifierModel,
    required super.name,
    required super.shortDescription,
    required super.description,
    required super.imageLarge,
    required super.imageSmall,
    this.authors = const [],
    this.features = const [],
  }) : super(slug: identifierModel.slug, authors: authors, features: features);

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
