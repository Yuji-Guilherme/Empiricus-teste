import 'package:equatable/equatable.dart';

class FeatureEntity extends Equatable {
  final String title;
  final String description;

  const FeatureEntity({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}
