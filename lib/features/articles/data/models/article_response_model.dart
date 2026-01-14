import 'package:json_annotation/json_annotation.dart';
import 'article_model.dart';

part 'article_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ArticleResponseModel {
  final List<ArticleModel> groups;

  const ArticleResponseModel({required this.groups});

  factory ArticleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleResponseModelToJson(this);
}
