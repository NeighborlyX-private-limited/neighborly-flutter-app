import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.userName,
    super.title,
    super.content,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    required super.id,
    super.multimedia,
    required super.proPic,
    required super.city,
    required super.commentCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['contentid'],
      userId: json['userid'],
      userName: json['username'],
      title: json['title'],
      content: json['body'],
      createdAt: json['createdat'],
      cheers: json['cheers'],
      bools: json['boos'],
      multimedia: json['multimedia'],
      proPic: json['userProfilePicture'],
      city: json['city'],
      commentCount: json['commentCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'cheers': cheers,
      'bools': bools,
      'multimedia': multimedia,
    };
  }
}
