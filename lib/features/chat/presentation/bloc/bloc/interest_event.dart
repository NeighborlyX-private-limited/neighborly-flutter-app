part of 'interest_bloc.dart';

sealed class InterestEvent extends Equatable {
  const InterestEvent();

  @override
  List<Object> get props => [];
}

class FeatchInterestEvent extends InterestEvent {
  const FeatchInterestEvent();
}
