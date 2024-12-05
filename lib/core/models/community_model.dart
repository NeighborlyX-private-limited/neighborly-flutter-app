import 'dart:convert';

import '../entities/community_entity.dart';
import 'user_simple_model.dart';

class CommunityModel extends CommunityEntity {
  const CommunityModel({
    required super.id,
    required super.name,
    required super.description,
    required super.locationStr,
    required super.createdAt,
    required super.avatarUrl,
    required super.karma,
    required super.membersCount,
    required super.isPublic,
    required super.isJoined,
    required super.isMuted,
    required super.users,
    required super.admins,
    required super.blockList,
    super.radius,
    super.latLong,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'avatarUrl': avatarUrl,
      'karma': karma,
      'radius': radius,
      'membersCount': membersCount,
      'isPublic': isPublic,
      'isJoined': isJoined,
      'isMuted': isMuted,
      'users': users.map((x) => x.toMap()).toList(),
      'admins': admins.map((x) => x.toMap()).toList(),
      'blockList': blockList.map((x) => x.toMap()).toList(),
      'locationStr': locationStr,
      'latLong': latLong,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      id: map['id'] ?? map['_id'] ?? "0",
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] ?? '',
      avatarUrl: map['image'] ?? map['icon'] ?? '',
      karma: map['karma'] ?? 0,
      radius: map['radius'] ?? 0,
      membersCount: map['membersCount'] ?? 0,
      isPublic: map['isOpen'] ?? map['isPublic'] ?? false,
      isJoined: map['isJoined'] ?? map['isJoined'] ?? false,
      isMuted: map['isMuted'] ?? map['isMuted'] ?? false,
      users: map['members'] != null
          ? List<UserSimpleModel>.from(
              map['members']?.map((x) => UserSimpleModel.fromMap(x)))
          : [],
      admins: map['admin'] != null
          ? List<UserSimpleModel>.from(
              map['admin']?.map((x) => UserSimpleModel.fromMap(x)))
          : [],
      blockList: map['blockList'] != null
          ? List<UserSimpleModel>.from(
              map['blockList']?.map((x) => UserSimpleModel.fromMap(x)))
          : [],
      locationStr: map['locationStr'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityModel.fromJson(Map<String, dynamic> source) =>
      CommunityModel.fromMap(source);

  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    String? createdAt,
    String? avatarUrl,
    num? karma,
    num? radius,
    num? membersCount,
    bool? isPublic,
    bool? isJoined,
    bool? isMuted,
    List<UserSimpleModel>? users,
    List<UserSimpleModel>? admins,
    List<UserSimpleModel>? blockList,
    String? locationStr,
    List<double>? latLong,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      karma: karma ?? this.karma,
      radius: radius ?? this.radius,
      membersCount: membersCount ?? this.membersCount,
      isPublic: isPublic ?? this.isPublic,
      isJoined: isJoined ?? this.isJoined,
      isMuted: isMuted ?? this.isMuted,
      users: users ?? this.users,
      admins: admins ?? this.admins,
      blockList: blockList ?? this.blockList,
      locationStr: locationStr ?? this.locationStr,
      latLong: latLong ?? this.latLong,
    );
  }

  @override
  String toString() {
    return 'CommunityModel(id: $id, name: $name, avatarUrl: $avatarUrl, karma: $karma, radius: $radius, membersCount: $membersCount, isPublic: $isPublic, isJoined: $isJoined, usersC: ${users.length}, adminsC: ${admins.length}, blockListC: ${blockList.length}, locationStr: $locationStr, latLong: $latLong)';
  }

  static List<CommunityModel> fromJsonList(List<dynamic> json) {
    var list = <CommunityModel>[];

    if (json.isNotEmpty) {
      list = json
          .map<CommunityModel>((jsomItem) => CommunityModel.fromMap(jsomItem))
          .toList();
    }

    return list;
  }
}
