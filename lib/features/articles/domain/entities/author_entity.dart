import 'package:equatable/equatable.dart';

class AuthorEntity extends Equatable {
  final String name;
  final String? photoSmallUrl;
  final String? photoLargeUrl;
  final String? description;

  const AuthorEntity({
    required this.name,
    this.photoSmallUrl,
    this.photoLargeUrl,
    this.description,
  });

  @override
  List<Object?> get props => [name, photoSmallUrl];
}
