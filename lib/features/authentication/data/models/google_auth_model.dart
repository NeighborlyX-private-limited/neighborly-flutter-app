import 'package:neighborly_flutter_app/features/authentication/domain/entities/google_auth_entity.dart';

class GoogleAuthModel extends GoogleAuthEntitiy {
  const GoogleAuthModel({
    required super.id,
    required super.username,
    required super.token,
    super.isVerified = true,
    required super.email,
    super.coordinates = const [0, 0],
    required super.picture,
    super.findMe = true,
  });

  factory GoogleAuthModel.fromJson(Map<String, dynamic> json) {
    return GoogleAuthModel(
      id: json['access_token'],
      username: json['user_info']['name'],
      token: json['token'],
      email: json['user_info']['email'],
      picture: json['user_info']['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'token': token,
      'isVerified': isVerified,
      'email': email,
      'coordinates': coordinates,
      'picture': picture,
      'findMe': findMe,
    };
  }
}
