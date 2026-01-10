import 'package:json_annotation/json_annotation.dart';

part 'feature_model.g.dart';

@JsonSerializable()
class FeatureModel {
  final String title;
  final String description;

  const FeatureModel({required this.title, required this.description});

  factory FeatureModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureModelToJson(this);
}
