import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final num id;
  final String userId;
  final String userName;
  final String? title;
  final String? content;
  final String? multimedia; // Made nullable
  final String createdAt;
  final num cheers;
  final num bools;
  final String proPic;
  final String city;
  final num commentCount;

  const PostEntity({
    required this.city,
    required this.id,
    required this.userId,
    required this.userName,
    required this.commentCount,
    this.title,
    this.content,
    required this.createdAt,
    required this.cheers,
    required this.bools,
    required this.proPic,
    this.multimedia, // Made nullable
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        commentCount,
        title,
        content,
        createdAt,
        cheers,
        city,
        proPic,
        bools,
        multimedia, // Nullable in props list
      ];
}
