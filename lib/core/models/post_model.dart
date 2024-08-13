import 'package:neighborly_flutter_app/core/models/option_model.dart';
import 'package:neighborly_flutter_app/core/entities/post_enitity.dart';

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
    super.allowMultipleVotes,
    super.multimedia,
    super.proPic,
    required super.city,
    required super.commentCount,
    required super.awardType,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['contentid'], // Assuming contentid is always an int
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
      cheers: json['cheers'],
      bools: json['boos'],
      multimedia: json['multimedia'],
      proPic: json['userProfilePicture'] as String?,
      city: json['city'] as String,
      commentCount: json['commentCount'],
      allowMultipleVotes: json['allow_multiple_votes'],
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
      'city': city,
      'commentCount': commentCount,
      'type': type,
      'cheers': cheers,
      'boos': bools,
      'multimedia': multimedia,
      'awards': awardType,
    };
  }
}
