// lib/presentation/bloc/reward_state.dart

part of 'request_history_bloc.dart';

abstract class RequestHistoryState {}

class RequestHistoryInitial extends RequestHistoryState {}

class RequestHistoryLoading extends RequestHistoryState {}

class RequestHistoryLoaded extends RequestHistoryState {
  final RewardRequestHistoryModel data;
  // final List<RewardRequestHistoryModel> data;

  RequestHistoryLoaded(this.data);
}

class RequestHistoryError extends RequestHistoryState {
  final String message;

  RequestHistoryError(this.message);
}
