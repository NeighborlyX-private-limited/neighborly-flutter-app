import 'package:equatable/equatable.dart';

import '../../../../core/entities/post_enitity.dart';

class SpecificCommentEntity extends Equatable {
  final String userId;
  final String userName;
  // final String commentorPic;
  final String commentText;
  final num commentId;
  final PostEntity content;
  final String createdAt;
  final num cheers;
  final num bools;
  final List<dynamic> awardType;

  const SpecificCommentEntity({
    required this.userId,
    required this.userName,
    // required this.commentorPic,
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
        // commentorPic
      ];
}
