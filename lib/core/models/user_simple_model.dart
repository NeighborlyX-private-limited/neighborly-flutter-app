import 'dart:convert';

import '../entities/user_simple_entity.dart';

class UserSimpleModel extends UserSimpleEntity {
  const UserSimpleModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    super.isAdmin,
    super.karma,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'isAdmin': isAdmin,
      'karma': karma,
    };
  }

  factory UserSimpleModel.fromMap(Map<String, dynamic> map) {
    return UserSimpleModel(
      id: map['userId'] ?? "0",
      name: map['userName'] ?? '',
      avatarUrl: map['picture'] ??
          'https://eu.ui-avatars.com/api/?name=${map['name']}&background=random&rounded=true',
      isAdmin: map['isAdmin'] ?? false,
      karma: map['karma'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSimpleModel.fromJson(String source) =>
      UserSimpleModel.fromMap(json.decode(source));

  static List<UserSimpleModel> fromJsonList(List<dynamic> json) {
    var list = <UserSimpleModel>[];

    if (json.isNotEmpty) {
      list =
          json.map((jsomItem) => UserSimpleModel.fromJson(jsomItem)).toList();
    }

    return list;
  }

  UserSimpleModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isAdmin,
  }) {
    return UserSimpleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  String toString() {
    return 'UserSimpleModel(id: $id, name: $name, avatarUrl: $avatarUrl, isAdmin: $isAdmin, karma: $karma)';
  }
}
