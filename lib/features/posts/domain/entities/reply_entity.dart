import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final num optionId;
  final String option;
  final String votes;

  const ReplyEntity({
    required this.optionId,
    required this.option,
    required this.votes,
  });

  @override
  List<Object?> get props => [
        option,
        optionId,
        votes,
      ];
}
