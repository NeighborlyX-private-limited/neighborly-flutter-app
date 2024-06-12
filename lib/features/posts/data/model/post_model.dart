import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.userName,
    required super.title,
    required super.content,
    required super.createdAt,
    required super.cheers,
    required super.bools,
    required super.id,
    super.multimedia,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['postid'],
      userId: json['userid'],
      userName: json['username'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdat'],
      cheers: json['cheers'],
      bools: json['boos'],
      multimedia: json['multimedia'],
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
