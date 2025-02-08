class PinnedMessageEntity {
  final String id;
  final String groupId;
  final String name;
  final String userId;
  final String message;
  final String userpicture;
  final List<String> readBy;
  final String? mediaLink;
  final String? parentMessageId;
  final int cheers;
  final int boos;
  final bool isPinned;
  final DateTime sendAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PinnedMessageEntity({
    required this.id,
    required this.groupId,
    required this.name,
    required this.userpicture,
    required this.userId,
    required this.message,
    required this.readBy,
    this.mediaLink,
    this.parentMessageId,
    required this.cheers,
    required this.boos,
    required this.isPinned,
    required this.sendAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
