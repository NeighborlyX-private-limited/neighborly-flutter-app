// lib/presentation/bloc/reward_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/domain/usecase/get_request_history_usecase.dart';

import '../../data/model/request_history_model.dart';
import '../../data/model/reward_model.dart';
import '../../domain/usecase/get_reward_details_usecase.dart';

part 'request_history_event.dart';
part 'request_history_state.dart';

class RequestHistoryBloc
    extends Bloc<RequestHistoryEvent, RequestHistoryState> {
  final GetRequestHistoryUseCase useCase;

  RequestHistoryBloc(this.useCase) : super(RequestHistoryInitial()) {
    on<LoadRequestHistory>((event, emit) async {
      emit(RequestHistoryLoading());
      try {
        final RewardRequestHistoryModel data = await useCase();
        // final List<RewardRequestHistoryModel> data = await useCase();
        emit(RequestHistoryLoaded(data));
      } catch (e) {
        emit(RequestHistoryError(e.toString()));
      }
    });
  }
}
