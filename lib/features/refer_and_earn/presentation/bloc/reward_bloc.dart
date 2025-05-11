// lib/presentation/bloc/reward_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/reward_model.dart';
import '../../domain/usecase/get_reward_details_usecase.dart';

part 'reward_event.dart';
part 'reward_state.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final GetRewardDetailsUseCase useCase;

  RewardBloc(this.useCase) : super(RewardInitial()) {
    on<LoadRewardDetails>((event, emit) async {
      emit(RewardLoading());
      try {
        final data = await useCase();
        emit(RewardLoaded(data));
      } catch (e) {
        emit(RewardError("Failed to load rewards"));
      }
    });
  }
}
