import 'package:empiricus_test/features/articles/domain/entities/feature_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feature_model.g.dart';

@JsonSerializable()
class FeatureModel extends FeatureEntity {
  const FeatureModel({required super.title, required super.description});

  factory FeatureModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureModelToJson(this);
}
