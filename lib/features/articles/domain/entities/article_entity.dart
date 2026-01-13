import 'package:empiricus_test/features/articles/domain/entities/author_entity.dart';
import 'package:empiricus_test/features/articles/domain/entities/feature_entity.dart';
import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String slug;
  final String name;
  final String shortDescription;
  final String description;
  final String imageLarge;
  final String imageSmall;
  final List<AuthorEntity> authors;
  final List<FeatureEntity> features;

  const ArticleEntity({
    required this.slug,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.imageLarge,
    required this.imageSmall,
    this.authors = const [],
    this.features = const [],
  });

  @override
  List<Object?> get props => [slug, name, authors, features];
}
