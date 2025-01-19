import 'package:neighborly_flutter_app/features/posts/domain/entities/specific_comment_entity.dart';

import '../../../../core/models/post_model.dart';

class SpecificCommentModel extends SpecificCommentEntity {
  const SpecificCommentModel({
    required super.userId,
    required super.userName,
    // required super.commentorPic,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    required super.awardType,
    required super.commentText,
    required super.commentId,
    required super.content,
  });

  factory SpecificCommentModel.fromJson(Map<String, dynamic> json) {
    return SpecificCommentModel(
      awardType: json['awards'] as List<dynamic>,
      userId: json['userid'] as String,
      userName: json['username'] as String,
      // commentorPic: json['commenterProfilePicture'] as String,
      content: PostModel.fromJson(json['content'] as Map<String, dynamic>),
      createdAt: json['createdat'] as String,
      cheers: json['cheers'],
      bools: json['boos'],
      commentText: json['text'],
      commentId: json['commentid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt,
      'cheers': cheers,
      'boos': bools,
      'awards': awardType,
      'text': commentText,
      'commentid': commentId,
      'content': content,
      // 'commentorPic': commentorPic
    };
  }
}
