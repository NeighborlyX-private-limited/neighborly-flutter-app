part of 'vote_poll_bloc.dart';

abstract class VotePollState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VotePollInitialState extends VotePollState {
  VotePollInitialState();
}

class VotePollLoadingState extends VotePollState {
  VotePollLoadingState();
}

class VotePollSuccessState extends VotePollState {
  VotePollSuccessState();
}

class VotePollFailureState extends VotePollState {
  final String error;
  VotePollFailureState({required this.error});
}
