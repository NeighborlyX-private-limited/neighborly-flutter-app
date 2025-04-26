import 'package:equatable/equatable.dart';

class NearbyUserEntity extends Equatable {
  final String id;
  final String username;
  final String picture;
  final List<String> interests;
  final double distance;

  const NearbyUserEntity({
    required this.id,
    required this.username,
    required this.picture,
    required this.interests,
    required this.distance,
  });

  @override
  List<Object?> get props => [id, username, picture, interests, distance];
}
