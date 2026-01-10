// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) => AuthorModel(
  name: json['name'] as String,
  photoSmallUrl: json['photoSmallUrl'] as String?,
  photoLargeUrl: json['photoLargeUrl'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$AuthorModelToJson(AuthorModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'photoSmallUrl': instance.photoSmallUrl,
      'photoLargeUrl': instance.photoLargeUrl,
      'description': instance.description,
    };
