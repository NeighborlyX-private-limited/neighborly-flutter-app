part of 'event_detail_cubit.dart';

class EventDetailState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final String? successMessage;
  final File? imageToUpload;
  final String newEventId;
  final EventModel? eventDetails;

  const EventDetailState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.successMessage = '',
    this.newEventId = '',
    this.imageToUpload,
    this.eventDetails,
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        successMessage,
        imageToUpload,
        newEventId,
        eventDetails,
      ];

  EventDetailState copyWith(
      {Status? status,
      Failure? failure,
      String? errorMessage,
      String? successMessage,
      File? imageToUpload,
      String? newEventId,
      EventModel? eventDetails}) {
    print('---eventDetails=${eventDetails?.id}');
    print('---this.eventDetails=${this.eventDetails?.id}');
    return EventDetailState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      newEventId: newEventId ?? this.newEventId,
      eventDetails: eventDetails ?? this.eventDetails,
      // eventDetails: eventDetails ,
    );
  }
}
