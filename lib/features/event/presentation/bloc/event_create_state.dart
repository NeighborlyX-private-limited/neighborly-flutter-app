part of 'event_create_cubit.dart';

class EventCreateState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final String? successMessage;
  final File? imageToUpload;
  final String? imageUrl;
  final String eventId;
  final String? dateStart;
  final String? hourStart;
  final String? dateEnd;
  final String? hourEnd;
  final String? category;
  final bool? isUpdate;
  final EventModel? newEvent;

  const EventCreateState(
      {this.status = Status.initial,
      this.failure,
      this.successMessage = '',
      this.errorMessage = '',
      this.eventId = '',
      this.imageUrl = '',
      this.imageToUpload,
      this.dateStart = '',
      this.hourStart = '',
      this.dateEnd = '',
      this.hourEnd = '',
      this.category = '',
      this.isUpdate = false,
      this.newEvent});

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        successMessage,
        imageToUpload,
        eventId,
        dateStart,
        dateEnd,
        category,
        imageUrl,
        hourStart,
        hourEnd,
        newEvent,
      ];

  EventCreateState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    String? successMessage,
    File? imageToUpload,
    String? eventId,
    String? dateStart,
    String? hourStart,
    String? dateEnd,
    String? hourEnd,
    String? category,
    String? imageUrl,
    bool? isUpdate,
    EventModel? newEvent,
  }) {
    return EventCreateState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      eventId: eventId ?? this.eventId,
      dateStart: dateStart ?? this.dateStart,
      hourStart: hourStart ?? this.hourStart,
      dateEnd: dateEnd ?? this.dateEnd,
      hourEnd: hourEnd ?? this.hourEnd,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isUpdate: isUpdate ?? this.isUpdate,
      newEvent: newEvent ?? this.newEvent,
    );
  }
}
