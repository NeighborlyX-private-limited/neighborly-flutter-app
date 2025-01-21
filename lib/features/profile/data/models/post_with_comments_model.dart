import '../../../../core/models/post_model.dart';
import '../../domain/entities/post_with_comments_entity.dart';

class PostWithCommentsModel extends PostWithCommentsEntity {
  const PostWithCommentsModel({
    required super.userId,
    required super.userName,
    required super.commenterProfilePicture,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    required super.awardType,
    required super.commentText,
    required super.commentId,
    required super.content,
  });

  factory PostWithCommentsModel.fromJson(Map<String, dynamic> json) {
    return PostWithCommentsModel(
      awardType: json['awards'] as List<dynamic>,
      userId: json['userid'] as String,
      userName: json['username'] as String,
      commenterProfilePicture: json['commenterProfilePicture'] as String,
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
      'commenterProfilePicture': commenterProfilePicture,
    };
  }
}
