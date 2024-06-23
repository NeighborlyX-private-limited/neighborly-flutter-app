import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.awardType,
    required super.commentid,
    required super.userId,
    required super.userName,
    required super.text,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    super.proPic,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentid: json['commentid'],
      userId: json['userid'],
      userName: json['username'],
      text: json['text'],
      createdAt: json['createdat'],
      cheers: json['cheers'],
      bools: json['boos'],
      proPic: json['user_picture'],
      awardType: (json['award_type'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentid': commentid,
      'userId': userId,
      'userName': userName,
      'text': text,
      'createdAt': createdAt,
      'cheers': cheers,
      'bools': bools,
      'proPic': proPic,
      'awardType': awardType,
    };
  }
}
