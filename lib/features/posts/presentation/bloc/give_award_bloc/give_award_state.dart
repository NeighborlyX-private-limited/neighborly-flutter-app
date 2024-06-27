part of 'give_award_bloc.dart';

abstract class GiveAwardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GiveAwardInitialState extends GiveAwardState {
  GiveAwardInitialState();
}

class GiveAwardLoadingState extends GiveAwardState {
  GiveAwardLoadingState();
}

class GiveAwardSuccessState extends GiveAwardState {
  GiveAwardSuccessState();
}

class GiveAwardFailureState extends GiveAwardState {
  final String error;
  GiveAwardFailureState({required this.error});
}
