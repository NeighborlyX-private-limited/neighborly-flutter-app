part of 'vote_poll_bloc.dart';

abstract class VotePollEvent extends Equatable {}

class VotePollButtonPressedEvent extends VotePollEvent {
  final num pollId;
  final num optionId;

  VotePollButtonPressedEvent({required this.pollId, required this.optionId});

  @override
  List<Object?> get props => [pollId, optionId];
}
