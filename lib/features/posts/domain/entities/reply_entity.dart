import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final num id;
  final String userId;
  final String userName;
  final String text;
  final List<String> awardType;
  final String createdAt;
  final num cheers;
  final num bools;
  final String? proPic;
  final String? userFeedback;

  const ReplyEntity(
      {required this.awardType,
      required this.id,
      required this.userId,
      required this.userName,
      required this.text,
      required this.createdAt,
      required this.cheers,
      required this.bools,
      this.proPic,
      required this.userFeedback});

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        text,
        createdAt,
        cheers,
        bools,
        proPic,
        awardType,
        userFeedback
      ];
}
