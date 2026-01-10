// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponseModel _$ArticleResponseModelFromJson(
  Map<String, dynamic> json,
) => ArticleResponseModel(
  groups: (json['groups'] as List<dynamic>)
      .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ArticleResponseModelToJson(
  ArticleResponseModel instance,
) => <String, dynamic>{
  'groups': instance.groups.map((e) => e.toJson()).toList(),
};
