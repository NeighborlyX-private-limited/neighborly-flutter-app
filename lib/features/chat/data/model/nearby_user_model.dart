import '../../domain/entities/nearby_user_entity.dart';

class NearbyUserModel extends NearbyUserEntity {
  const NearbyUserModel({
    required super.id,
    required super.username,
    required super.picture,
    required super.interests,
    required super.distance,
  });

  factory NearbyUserModel.fromJson(Map<String, dynamic> json) {
    return NearbyUserModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      picture: json['picture'] as String,
      interests: List<String>.from(json['interests'] ?? []),
      distance: (json['distance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'picture': picture,
      'interests': interests,
      'distance': distance,
    };
  }
}
