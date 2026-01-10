// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
  identifier: ArticleIdentifier.fromJson(
    json['identifier'] as Map<String, dynamic>,
  ),
  name: json['name'] as String,
  shortDescription: json['shortDescription'] as String,
  description: json['description'] as String,
  imageLarge: json['imageLarge'] as String,
  imageSmall: json['imageSmall'] as String,
  authors:
      (json['authors'] as List<dynamic>?)
          ?.map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  features:
      (json['features'] as List<dynamic>?)
          ?.map((e) => FeatureModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'identifier': instance.identifier.toJson(),
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'description': instance.description,
      'imageLarge': instance.imageLarge,
      'imageSmall': instance.imageSmall,
      'authors': instance.authors.map((e) => e.toJson()).toList(),
      'features': instance.features.map((e) => e.toJson()).toList(),
    };

ArticleIdentifier _$ArticleIdentifierFromJson(Map<String, dynamic> json) =>
    ArticleIdentifier(slug: json['slug'] as String);

Map<String, dynamic> _$ArticleIdentifierToJson(ArticleIdentifier instance) =>
    <String, dynamic>{'slug': instance.slug};
