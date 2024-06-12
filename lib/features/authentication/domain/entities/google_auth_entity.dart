import 'package:equatable/equatable.dart';

class GoogleAuthEntitiy extends Equatable {
  final String id;
  final String username;
  final String token;
  final bool? isVerified;
  final String email;
  final bool? findMe;
  final List<dynamic>? coordinates;
  final String picture;

  const GoogleAuthEntitiy({
    required this.email,
    this.findMe = true,
    this.coordinates = const [0, 0],
    required this.picture,
    required this.id,
    this.isVerified = true,
    required this.username,
    required this.token,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        token,
        isVerified,
        email,
        findMe,
        coordinates,
        picture,
      ];
}
