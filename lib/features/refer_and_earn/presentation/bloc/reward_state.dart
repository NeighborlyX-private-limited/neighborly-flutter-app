// lib/presentation/bloc/reward_state.dart

part of 'reward_bloc.dart';

abstract class RewardState {}

class RewardInitial extends RewardState {}

class RewardLoading extends RewardState {}

class RewardLoaded extends RewardState {
  final RewardModel data;

  RewardLoaded(this.data);
}

class RewardError extends RewardState {
  final String message;

  RewardError(this.message);
}
