import 'dart:io';
import 'package:equatable/equatable.dart';

import '../../../../core/models/user_simple_model.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String text;
  final String date;
  final bool isMine;
  final bool isReaded;
  final bool hasMore;
  final bool isAdmin;
  final bool isPinned;
  final int repliesCount;  
  final int cheers;
  final int bools;
  final String boolOrCheer;
  final File? pictureAsset;
  final String? pictureUrl;
  final List<String> repliesAvatas;
  final UserSimpleModel? author;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.date,
    required this.isMine,
    required this.isReaded,
    required this.hasMore,
    required this.isAdmin,
    required this.isPinned,
    required this.repliesCount,
    required this.cheers,
    required this.bools,
    required this.boolOrCheer,
    this.pictureAsset,
    this.pictureUrl,
    required this.repliesAvatas,
    this.author,
  });

  @override
  List<Object?> get props => [id];
}
