class GroupJoinRequestEntity {
  final String id;
  final String groupId;
  final String userId;
  final String username;
  final String userpic;
  final String email;
  final String status;
  final DateTime requestedAt;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String message;

  const GroupJoinRequestEntity({
    required this.id,
    required this.groupId,
    required this.userpic,
    required this.userId,
    required this.username,
    required this.email,
    required this.status,
    required this.requestedAt,
    this.resolvedAt,
    this.resolvedBy,
    required this.message,
  });
}
