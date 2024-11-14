import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../../domain/usecases/get_all_events_usecase.dart';

part 'event_main_state.dart';

class EventMainCubit extends Cubit<EventMainState> {
  final GetEventsUsecase getEventsUsecase;
  EventMainCubit(
    this.getEventsUsecase,
  ) : super(const EventMainState());

  void init() async {
    GetLocalEvents(scope: 'byUser');
    GetMyEvents();
    GetGoingEvents();
  }

  Future GetLocalEvents({required String scope}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getEventsUsecase(
      scope: scope,
      myOrOngoing: '',
      searchTerm: '',
      filterDateStart: '',
      filterDateEnd: '',
      filterCategory: '',
      filterLocation: '',
    );

    result.fold(
      (failure) {
        print('... BLOC GetLocalEvents error: $failure');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (eventsLocalList) {
        print('... BLOC GetLocalEvents results: $eventsLocalList');
        emit(state.copyWith(
            status: Status.success, eventsLocal: eventsLocalList));
      },
    );
  }

  Future GetMyEvents() async {
    emit(state.copyWith(status: Status.loading));
    final result = await getEventsUsecase(
      scope: 'local',
      myOrOngoing: 'mine',
      searchTerm: '',
      filterDateStart: '',
      filterDateEnd: '',
      filterCategory: '',
      filterLocation: '',
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (eventsMineList) {
        emit(
            state.copyWith(status: Status.success, eventsMine: eventsMineList));
      },
    );
  }

  Future GetGoingEvents() async {
    emit(state.copyWith(status: Status.loading));
    final result = await getEventsUsecase(
      scope: 'local',
      myOrOngoing: 'mine',
      searchTerm: '',
      filterDateStart: '',
      filterDateEnd: '',
      filterCategory: '',
      filterLocation: '',
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (eventsGoingList) {
        emit(state.copyWith(
            status: Status.success, eventsGoing: eventsGoingList));
      },
    );
  }
}
