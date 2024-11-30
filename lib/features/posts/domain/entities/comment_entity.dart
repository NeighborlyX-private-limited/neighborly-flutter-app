import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final num commentid;
  final String userId;
  final String userName;
  final String text;
  final List<String> awardType;
  final String createdAt;
  final num cheers;
  final num bools;
  final String? proPic;
  final String? userFeedback;
  final String? postid;

  const CommentEntity({
    required this.awardType,
    required this.commentid,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
    required this.cheers,
    required this.bools,
    this.proPic,
    required this.userFeedback,
    required this.postid,
  });

  @override
  List<Object?> get props => [
        commentid,
        userId,
        userName,
        text,
        createdAt,
        cheers,
        bools,
        proPic,
        awardType,
        userFeedback,
        postid
      ];
}
