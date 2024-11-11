import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../../domain/usecases/join_event_usecase.dart';

part 'event_join_state.dart';

class EventJoinCubit extends Cubit<EventJoinState> {
  final JoinEventUsecase joinEventUsecase;
  EventJoinCubit(
    this.joinEventUsecase,
  ) : super(const EventJoinState());

  void init(EventModel event) async {
    print('... BLOC - INIT event?=$event');

    emit(state.copyWith(eventJoin: event));
  }

  Future onPressRegister(
      {required String name,
      required String email,
      required String phone,
      required String gender}) async {
    print('...BLOC eventDetail onPressRegister=${state.eventJoin} ');
    emit(state.copyWith(status: Status.loading));

    final result = await joinEventUsecase(
      event: state.eventJoin!,
    );

    await Future.delayed(Duration(seconds: 4));

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (noResponse) {
        emit(state.copyWith(
            status: Status.success,
            successMessage: 'Event joined',
            eventJoin: state.eventJoin!.copyWith(isJoined: true)));
      },
    );
  }
}
