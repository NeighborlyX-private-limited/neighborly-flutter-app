import 'package:equatable/equatable.dart';

import '../models/user_simple_model.dart';

class CommunityEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String avatarUrl;
  final num karma;
  final num? radius;
  final num membersCount;
  final bool isPublic; // isOpen
  final bool isJoined; // ??
  final bool isMuted; // ??
  final List<UserSimpleModel> users; // members
  final List<UserSimpleModel> admins; // admin
  final List<UserSimpleModel> blockList; // blockList

  final String? locationStr;
  final List<double>? latLong;

  const CommunityEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.avatarUrl,
    required this.karma,
    this.radius,
    required this.membersCount,
    required this.isPublic,
    required this.isJoined,
    required this.isMuted,
    required this.users,
    required this.admins,
    required this.blockList,
    this.locationStr,
    this.latLong,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
