import 'package:equatable/equatable.dart';

class OptionEntity extends Equatable {
  final num optionId;
  final String option;
  final num votes;
  final bool userVoted;

  const OptionEntity({
    required this.optionId,
    required this.option,
    required this.votes,
    required this.userVoted,
  });

  OptionEntity copyWith({
    num? optionId,
    String? option,
    num? votes,
    bool? userVoted,
  }) {
    return OptionEntity(
      optionId: optionId ?? this.optionId,
      option: option ?? this.option,
      votes: votes ?? this.votes,
      userVoted: userVoted ?? this.userVoted,
    );
  }

  @override
  List<Object?> get props => [
        option,
        optionId,
        votes,
        userVoted,
      ];
}
