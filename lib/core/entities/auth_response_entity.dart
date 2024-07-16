import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final String id;
  final String username;
  final String? token;
  final bool? isVerified;
  final String? email;
  final bool? findMe;
  final List<dynamic>? coordinates;
  final String picture;
  final num? awardsCount;
  final String? bio;
  final num? postCount;
  final String? mostProminentAward;
  final num? karma;
  final String? phoneNumber;

  const AuthResponseEntity({
    this.email,
    this.findMe = true,
    this.coordinates,
    this.phoneNumber,
    this.karma,
    this.mostProminentAward,
    this.bio,
    this.postCount,
    this.awardsCount,
    required this.picture,
    required this.id,
    this.isVerified,
    required this.username,
    this.token,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        token,
        isVerified,
        bio,
        awardsCount,
 
        mostProminentAward,
        email,
        karma,
        postCount,
        findMe,
        // coordinates,
        picture,
      ];
}
