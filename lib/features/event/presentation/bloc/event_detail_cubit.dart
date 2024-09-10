import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../../domain/usecases/cancel_event_usecase.dart';
import '../../domain/usecases/join_event_usecase.dart';

part 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final CancelEventUsecase cancelEventUsecase;
  final JoinEventUsecase joinEventUsecase;
  EventDetailCubit(
    this.cancelEventUsecase,
    this.joinEventUsecase,
  ) : super(const EventDetailState());

  void init(String eventId, EventModel event) async {
    print('... BLOC - INIT eventDetails?=${state.eventDetails}');

    // emit(state.copyWith(eventDetails: event, newEventId: eventId));

    emit(state.copyWith(
        eventDetails: EventModel(
            id: event.id,
            title: event.title,
            description: event.description,
            avatarUrl: event.avatarUrl,
            locationStr: event.locationStr,
            dateStart: event.dateStart,
            dateEnd: event.dateEnd,
            category: event.category,
            address: event.address,
            host: event.host,
            isJoined: event.isJoined,
            isMine: event.isMine),
        newEventId: event.id));
    print('...BLOC eventDetail eventId=${eventId} event=${event}');
    print('\n\n\n... BLOC - EVENT name=${state.eventDetails!.title}');
    print('... BLOC - EVENT isMine=${state.eventDetails!.isMine}');
    print('... BLOC - EVENT isJoined=${state.eventDetails!.isJoined}');
  }

  Future cancelEvent(String? reason) async {
    emit(state.copyWith(status: Status.loading));

    final result =
        await cancelEventUsecase(event: state.eventDetails!, reason: 'reason');

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (noResponse) {
        emit(state.copyWith(
            status: Status.success, successMessage: 'Event canceled'));
      },
    );
  }

  Future joinEvent(EventModel newEvent, String? reason) async {}

  Future onPressJoin() async {
    print('...BLOC eventDetail onPressJoin=${state.eventDetails} ');
    emit(state.copyWith(status: Status.loading));

    final result = await joinEventUsecase(
      event: state.eventDetails!,
    );

    // await Future.delayed(Duration(seconds: 4));

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
            eventDetails: state.eventDetails!.copyWith(isJoined: true)));
      },
    );
  }
}
