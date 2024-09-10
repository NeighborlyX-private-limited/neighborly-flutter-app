import 'dart:convert';

import '../../../../core/models/user_simple_model.dart';
import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.avatarUrl,
    required super.locationStr,
    required super.dateStart,
    required super.dateEnd,
    required super.category,
    required super.address,
    required super.host,
    required super.isJoined,
    required super.isMine,
    super.hourStart,
    super.hourEnd,
  });

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title,  avatarUrl: $avatarUrl, locationStr: $locationStr, dateStart: $dateStart, dateEnd: $dateEnd, category: $category, address: $address, host: $host)';
  } // isMine: ${isMine} , isJoined: ${isJoined},

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? avatarUrl,
    String? locationStr,
    String? dateStart,
    String? dateEnd,
    String? category,
    String? address,
    UserSimpleModel? host,
    bool? isJoined,
    bool? isMine,
    String? hourStart,
    String? hourEnd,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      locationStr: locationStr ?? this.locationStr,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      category: category ?? this.category,
      address: address ?? this.address,
      host: host ?? this.host,
      isJoined: isJoined ?? this.isJoined,
      isMine: isMine ?? this.isMine,
      hourStart: hourStart ?? this.hourStart,
      hourEnd: hourEnd ?? this.hourEnd,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'avatarUrl': avatarUrl,
      'locationStr': locationStr,
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'category': category,
      'isJoined': isJoined,
      'isMine': isMine,
      'address': address,
      'host': host.toMap(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      locationStr: map['locationStr'] ?? '',
      dateStart: map['dateStart'] ?? '',
      dateEnd: map['dateEnd'] ?? '',
      hourStart: map['hourStart'] ?? '',
      hourEnd: map['hourEnd'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      isJoined: map['isJoined'] ?? false,
      isMine: map['isMine'] ?? false,
      host: UserSimpleModel.fromMap(map['host']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  static List<EventModel> fromJsonList(List<dynamic> json) {
    var list = <EventModel>[];

    if (json.isNotEmpty) {
      list = json
          .map<EventModel>((jsomItem) => EventModel.fromMap(jsomItem))
          .toList();
    }

    return list;
  }
}
