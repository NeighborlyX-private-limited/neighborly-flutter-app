import '../../domain/entities/comment_entity.dart';




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
    required super.userFeedback,
    required super.postid,
    
  });

  factory CommentModel.fromJson(Map<String, dynamic> json, num postid) {
    return CommentModel(
        commentid: json['commentid'] as num,
        userId: json['userid'] as String,
        userName: json['username'] as String,
        text: json['text'] as String,
        createdAt: json['createdat'] as String,
        cheers: json['cheers'] as num,
        bools: json['boos'] as num,
        proPic: json['user_picture'] as String?,
        awardType: (json['award_type'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        userFeedback: json['userFeedback'] as String?,
        postid: postid.toString());
  }

  factory CommentModel.fromEntity(CommentEntity entity) {
    return CommentModel(
        commentid: entity.commentid,
        userName: entity.userName,
        createdAt: entity.createdAt,
        userId: entity.userId,
        text: entity.text,
        cheers: entity.cheers,
        bools: entity.bools,
        awardType: entity.awardType,
        userFeedback: entity.userFeedback,
        postid: entity.postid);
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
      'userFeedback': userFeedback,
      'postid': postid
    };
  }
}
