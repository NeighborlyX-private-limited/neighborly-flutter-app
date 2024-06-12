import 'package:neighborly_flutter_app/features/authentication/domain/entities/auth_response_entity.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.id,
    required super.username,
    required super.token,
    required super.isVerified,
    required super.email,
    // required super.coordinates,
    required super.picture,
    super.findMe = true,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      id: json['user']['_id'],
      username: json['user']['username'],
      token: json['token'],
      isVerified: json['user']['isVerified'],
      email: json['user']['email'],
      // coordinates: json['user']['home_coordinates']['coordinates'],
      picture: json['user']['picture'],
      findMe: json['user']['findMe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'token': token,
      'isVerified': isVerified,
      'email': email,
      // 'coordinates': coordinates,
      'picture': picture,
      'findMe': findMe,
    };
  }
}
