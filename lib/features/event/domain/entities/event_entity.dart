import 'package:equatable/equatable.dart';

import '../../../../core/models/user_simple_model.dart';

class EventEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String avatarUrl;
  final String locationStr;
  final String dateStart;
  final String dateEnd;
  final String? hourStart;
  final String? hourEnd;
  final String category;
  final String address;
  final UserSimpleModel host;
  final bool isJoined;
  final bool isMine;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.avatarUrl,
    required this.locationStr,
    required this.dateStart,
    required this.dateEnd,
    this.hourStart = '',
    this.hourEnd = '',
    required this.category,
    required this.address,
    required this.host,
    required this.isJoined,
    required this.isMine,
  });

  @override
  List<Object?> get props => [id, title, avatarUrl];
}
