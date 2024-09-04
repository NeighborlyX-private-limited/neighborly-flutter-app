part of 'event_search_cubit.dart';

class EventSearchState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final List<EventModel> eventsLocal;
  final String dateFilterStart;
  final String dateFilterEnd;
  final String categoryFilter;
  final String locationFilter;

  const EventSearchState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.eventsLocal = const [],
    this.dateFilterStart = '',
    this.dateFilterEnd = '',
    this.categoryFilter = '',
    this.locationFilter = '',
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        eventsLocal,
        dateFilterStart,
        dateFilterEnd,
        categoryFilter,
        locationFilter,
      ];

  EventSearchState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    List<EventModel>? eventsLocal,
    String? dateFilterStart,
    String? dateFilterEnd,
    String? categoryFilter,
    String? locationFilter,
  }) {
    return EventSearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      eventsLocal: eventsLocal ?? this.eventsLocal,
      dateFilterStart: dateFilterStart ?? this.dateFilterStart,
      dateFilterEnd: dateFilterEnd ?? this.dateFilterEnd,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      locationFilter: locationFilter ?? this.locationFilter,
    );
  }
}
