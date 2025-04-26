part of 'interest_bloc.dart';

sealed class InterestState extends Equatable {
  const InterestState();

  @override
  List<Object> get props => [];
}

final class InterestInitialState extends InterestState {}

final class InterestLoadingState extends InterestState {}

final class InterestSuccessState extends InterestState {
  final InterestEntity interests;

  const InterestSuccessState({required this.interests});
}

final class InterestFailureState extends InterestState {
  final String error;
  const InterestFailureState({required this.error});
}
