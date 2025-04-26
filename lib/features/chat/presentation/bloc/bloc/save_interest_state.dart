part of 'save_interest_bloc.dart';

sealed class SaveInterestState extends Equatable {
  const SaveInterestState();

  @override
  List<Object> get props => [];
}

final class SaveInterestInitialState extends SaveInterestState {}

final class SaveInterestLoadingState extends SaveInterestState {}

final class SaveInterestSuccessState extends SaveInterestState {}

final class SaveInterestFailureState extends SaveInterestState {
  final String error;
  const SaveInterestFailureState({required this.error});
}
