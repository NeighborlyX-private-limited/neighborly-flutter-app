import '../entities/post_enitity.dart';
import 'option_model.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.userName,
    required super.type,
    required super.awardCount,
    super.title,
    super.thumbnail,
    super.content,
    super.pollOptions,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    required super.id,
    super.allowMultipleVotes,
    required super.multimedia,
    super.proPic,
    required super.city,
    required super.commentCount,
    required super.awardType,
    required super.userFeedback,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      // awardCount: '0',
      awardCount: json['award_count'] ?? '0',
      id: json['contentid'],
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
      thumbnail: json['thumbnail'] ?? '',
      content: json['body'] as String? ?? '',
      createdAt: json['createdat'] as String? ?? '',
      cheers: json['cheers'] ?? 0,
      bools: json['boos'] ?? 0,
      multimedia: (json['multimedia'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
      proPic: json['userProfilePicture'] as String? ?? '',
      city: json['city'] as String? ?? '',
      commentCount: json['commentCount'] ??
          (json['comment_count'] != null
              ? int.tryParse(json['comment_count'].toString()) ?? 0
              : 0),

      // commentCount:
      //     json['commentCount'] ?? int.parse(json['comment_count']) ?? 0,
      allowMultipleVotes: json['allow_multiple_votes'] ?? true,
      userFeedback: json['userFeedback'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'awardCount': awardCount,
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
      'userFeedback': userFeedback,
      'thumbnail': thumbnail
    };
  }
}
