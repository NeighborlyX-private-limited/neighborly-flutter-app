import 'package:equatable/equatable.dart';

class OptionEntity extends Equatable {
  final num optionId;
  final String option;
  final num votes;

  const OptionEntity({
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
