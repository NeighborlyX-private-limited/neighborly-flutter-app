import 'package:neighborly_flutter_app/core/entities/auth_response_entity.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.id,
    required super.username,
    required super.isVerified,
    required super.email,
    required super.coordinates,
    required super.picture,
    super.findMe = true,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      id: json['_id'],
      username: json['username'],
      isVerified: json['isVerified'],
      email: json['email'],
      coordinates: json['current_coordinates']['coordinates'],
      picture: json['picture'],
      findMe: json['findMe'],
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
