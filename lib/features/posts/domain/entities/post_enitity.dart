import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final num id;
  final String userId;
  final String userName;
  final String title;
  final String content;
  final String? multimedia; // Made nullable
  final String createdAt;
  final num cheers;
  final num bools;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.cheers,
    required this.bools,
    required this.multimedia, // Made nullable
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        title,
        content,
        createdAt,
        cheers,
        bools,
        multimedia, // Nullable in props list
      ];
}
