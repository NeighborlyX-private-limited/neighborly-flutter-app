import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../../domain/usecases/get_all_events_usecase.dart';

part 'event_search_state.dart';

class EventSearchCubit extends Cubit<EventSearchState> {
  final GetEventsUsecase getEventsUsecase;
  EventSearchCubit(
    this.getEventsUsecase,
  ) : super(const EventSearchState());

  void init() async {
    // GetLocalEvents(scope: 'byUser');
  }

  onUpdateCategory(String newCategoy) {
    print('...BLOC onUpdateCategory=$newCategoy');
    emit(state.copyWith(categoryFilter: newCategoy));
  }

  onUpdateLocation(String newLocation) {
    print('...BLOC onUpdateLocation=$newLocation');
    emit(state.copyWith(locationFilter: newLocation));
  }

  onUpdateDate(String newDateStart, String newDateEnd) {
    print('...BLOC onUpdateDate=$newDateStart  newDateEnd=$newDateEnd');
    emit(state.copyWith(
        dateFilterStart: newDateStart, dateFilterEnd: newDateEnd));
  }

  onPressSearch(String searchTerm) {
    GetLocalEvents(scope: '', searchTerm: searchTerm);
  }

  Future GetLocalEvents({required String scope, String? searchTerm}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getEventsUsecase(
      scope: scope,
      myOrOngoing: '',
      searchTerm: searchTerm ?? '',
      filterDateStart: state.dateFilterStart,
      filterDateEnd: state.dateFilterEnd,
      filterCategory: state.categoryFilter,
      filterLocation: state.locationFilter,
    );

    result.fold(
      (failure) {
        print('... BLOC GetLocalEvents error: ${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (eventsLocalList) {
        print('... BLOC GetLocalEvents results: ${eventsLocalList}');
        emit(state.copyWith(
            status: Status.success, eventsLocal: eventsLocalList));
      },
    );
  }
}
