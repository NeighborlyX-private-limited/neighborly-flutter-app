part of 'get_my_awards_bloc.dart';

abstract class GetMyAwardsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMyAwardsInitialState extends GetMyAwardsState {
  GetMyAwardsInitialState();
}

class GetMyAwardsLoadingState extends GetMyAwardsState {
  GetMyAwardsLoadingState();
}

class GetMyAwardsSuccessState extends GetMyAwardsState {
  final List<dynamic> awards;
  GetMyAwardsSuccessState({
    required this.awards,
  });
}

class GetMyAwardsFailureState extends GetMyAwardsState {
  final String error;
  GetMyAwardsFailureState({required this.error});
}
