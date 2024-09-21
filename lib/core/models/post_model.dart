import '../entities/post_enitity.dart';
import 'option_model.dart';

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
    required super.userFeedback
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['contentid'], // Assuming contentid is always an int
      awardType: (json['awards'] as List<dynamic>?) ?? [],
      type: json['type'] as String? ?? '',
      userId: json['userid'] as String? ?? '',
      pollOptions: json['pollResults'] != null
          ? (json['pollResults'] as List<dynamic>)
              .map((e) => OptionModel.fromJson(e))
              .toList()
          : [],
      userName: json['username'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['body'] as String? ?? '',
      createdAt: json['createdat'] as String? ?? '',
      cheers: json['cheers'] ?? 0,
      bools: json['boos'] ?? 0,
      multimedia: json['multimedia'] ?? '',
      proPic: json['userProfilePicture'] as String? ?? '',
      city: json['city'] as String? ?? '',
      commentCount: json['commentCount'] ?? 0,
      allowMultipleVotes: json['allow_multiple_votes'] ?? true,
      userFeedback: json['userFeedback'] ?? ''
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
      'userFeedback': userFeedback
    };
  }
}
