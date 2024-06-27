import 'package:neighborly_flutter_app/features/posts/data/model/option_model.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.userName,
    required super.type,
    super.title,
    super.content,
    super.pollOptions,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    required super.id,
    super.multimedia,
    super.proPic,
    required super.city,
    required super.commentCount,
    required super.awardType,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['contentid'] as int, // Assuming contentid is always an int
      awardType: json['awards'] as List<dynamic>,
      type: json['type'] as String,
      userId: json['userid'] as String,
      pollOptions: json['pollResults'] != null
          ? (json['pollResults'] as List<dynamic>)
              .map((e) => OptionModel.fromJson(e))
              .toList()
          : null,
      userName: json['username'] as String,
      title: json['title'] as String?,
      content: json['body'] as String?,
      createdAt: json['createdat'] as String,
      cheers: json['cheers'] as int,
      bools: json['boos'] as int,
      multimedia: json['multimedia'] as String?,
      proPic: json['userProfilePicture'] as String?,
      city: json['city'] as String,
      commentCount: json['commentCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentid': id,
      'userId': userId,
      'userName': userName,
      'title': title,
      'body': content,
      'createdAt': createdAt,
      'cheers': cheers,
      'boos': bools,
      'multimedia': multimedia,
      'awards': awardType,
    };
  }
}
