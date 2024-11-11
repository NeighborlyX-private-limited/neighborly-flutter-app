import 'dart:io';
import 'package:equatable/equatable.dart';

import '../../../../core/models/user_simple_model.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String text;
  final String date;
  final bool isMine;
  final bool readByuser;
  final bool hasMore;
  final bool isAdmin;
  final bool isPinned;
  final int repliesCount;
  final int cheers;
  final int boos;
  final String booOrCheer;
  final String? pictureUrl;
  final UserSimpleModel? author;

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.date,
    required this.isMine,
    required this.readByuser,
    required this.hasMore,
    required this.isAdmin,
    required this.isPinned,
    required this.repliesCount,
    required this.cheers,
    required this.boos,
    required this.booOrCheer,
    this.pictureUrl,
    this.author,
  });

  @override
  List<Object?> get props => [id];
}
