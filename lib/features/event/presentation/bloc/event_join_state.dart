part of 'event_join_cubit.dart';

class EventJoinState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final String? successMessage;
  final EventModel? eventJoin;

  const EventJoinState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.successMessage = '',
    this.eventJoin,
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        successMessage,
        eventJoin,
      ];

  EventJoinState copyWith(
      {Status? status,
      Failure? failure,
      String? errorMessage,
      String? successMessage,
      EventModel? eventJoin}) {
    return EventJoinState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,

      eventJoin: eventJoin ?? this.eventJoin,
      // eventJoin: eventJoin ,
    );
  }
}
