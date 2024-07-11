import 'package:neighborly_flutter_app/core/entities/auth_response_entity.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.id,
    required super.username,
    required super.email,
    required super.picture,
    super.awardsCount,
    super.bio,
    super.karma,
    super.mostProminentAward,
    super.postCount,
    // super.phoneNumber,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      id: json['user']['userId'],
      username: json['user']['username'],
      email: json['user']['email'],
      picture: json['user']['picture'],
      awardsCount: json['user']['awardsCount'],
      bio: json['user']['bio'],
      karma: json['user']['karma'],
      mostProminentAward: json['user']['mostProminentAward'],
      postCount: json['user']['postCount'],
      // phoneNumber: json['user']['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'picture': picture,
      'awards_count': awardsCount,
      'bio': bio,
      'karma': karma,
      'most_prominent_award': mostProminentAward,
      'post_count': postCount,
    };
  }
}
