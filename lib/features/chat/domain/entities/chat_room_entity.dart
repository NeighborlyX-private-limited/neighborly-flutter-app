 
 

import 'package:equatable/equatable.dart';

class ChatRoomEntity extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String lastMessageDate;
  final bool isMuted; 
  final bool isGroup; 
  final int unreadedCount;
  
  ChatRoomEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.isMuted,
    required this.isGroup,
    required this.unreadedCount,
  });

  
  @override 
  List<Object?> get props => [id, name];

}
