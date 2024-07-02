import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final String id;
  final String username;
  final String? token;
  final bool isVerified;
  final String email;
  final bool? findMe;
  final List<dynamic> coordinates;
  final String picture;

  const AuthResponseEntity({
    required this.email,
    this.findMe = true,
    required this.coordinates,
    required this.picture,
    required this.id,
    required this.isVerified,
    required this.username,
    this.token,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        token,
        isVerified,
        email,
        findMe,
        // coordinates,
        picture,
      ];
}
