part of 'event_main_cubit.dart';

class EventMainState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final List<EventModel> eventsLocal;
  final List<EventModel> eventsMine;
  final List<EventModel> eventsGoing;

  const EventMainState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.eventsLocal = const [],
    this.eventsMine = const [],
    this.eventsGoing = const [],
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        eventsLocal,
        eventsMine,
        eventsGoing,
      ];

  EventMainState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    List<EventModel>? eventsLocal,
    List<EventModel>? eventsMine,
    List<EventModel>? eventsGoing,
  }) {
    return EventMainState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      eventsLocal: eventsLocal ?? this.eventsLocal,
      eventsMine: eventsMine ?? this.eventsMine,
      eventsGoing: eventsGoing ?? this.eventsGoing,
    );
  }
}
