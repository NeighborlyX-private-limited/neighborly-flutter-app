import '../../domain/entities/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  const ReplyModel({
    required super.awardType,
    required super.id,
    required super.userId,
    required super.userName,
    required super.text,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    super.proPic,
    required super.userFeedback,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
        id: json['replyid'] as num,
        userId: json['userid'] as String,
        userName: json['username'] as String,
        text: json['text'] as String,
        createdAt: json['createdat'] as String,
        cheers: json['cheers'] as num,
        bools: json['boos'] as num,
        proPic: json['user_picture'] as String?,
        awardType:
            (json['awards'] as List<dynamic>).map((e) => e as String).toList(),
        userFeedback: json['userFeedback'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'commentid': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'createdAt': createdAt,
      'cheers': cheers,
      'bools': bools,
      'proPic': proPic,
      'awardType': awardType,
      'userFeedback': userFeedback
    };
  }
}
