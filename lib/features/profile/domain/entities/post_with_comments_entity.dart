import 'package:equatable/equatable.dart';

import '../../../../core/entities/post_enitity.dart';

class PostWithCommentsEntity extends Equatable {
  final String userId;
  final String userName;
  final String commentText;
  final String commenterProfilePicture;
  final num commentId;
  final PostEntity content;
  final String createdAt;
  final num cheers;
  final num bools;
  final List<dynamic> awardType;

  const PostWithCommentsEntity({
    required this.userId,
    required this.userName,
    required this.commenterProfilePicture,
    required this.commentText,
    required this.commentId,
    required this.content,
    required this.createdAt,
    required this.cheers,
    required this.bools,
    required this.awardType,
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        commentText,
        commentId,
        content,
        createdAt,
        cheers,
        bools,
        awardType,
        commenterProfilePicture
      ];
}
