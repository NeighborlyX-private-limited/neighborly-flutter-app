import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../../upload/domain/usecases/upload_file_usecase.dart';
import '../../data/model/event_model.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../domain/usecases/update_event_usecase.dart';

part 'event_create_state.dart';

class EventCreateCubit extends Cubit<EventCreateState> {
  final UploadFileUsecase uploadFileUsecase;
  final CreateEventUsecase createEventUsecase;
  final UpdateEventUsecase updateEventUsecase;

  EventCreateCubit(
    this.uploadFileUsecase,
    this.createEventUsecase,
    this.updateEventUsecase,
  ) : super(const EventCreateState());

  void init(EventModel? event) async {
    print('... BLOC init isUpdate=${(event != null)}');
    emit(state.copyWith(
      isUpdate: event != null,
      eventId: event?.id ?? '',
      imageUrl: event?.avatarUrl ?? '', 
    ));
  }

  Future onUpdateFile(File fileToUpload) async {
    var result = await uploadFileUsecase(file: fileToUpload);

    print('...BLOC onUpdateFile start');

    result.fold(
      (failure) {
        print('...BLOC onUpdateFile error: ${failure.message}');
        emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
      },
      (imageUrl) {
        print('... BLOC imageUrl=${imageUrl}');
        emit(state.copyWith(imageToUpload: fileToUpload, imageUrl: imageUrl));
      },
    );
  }

  String mergeDataTime(String date, String time) {
    if (date == '') return '';
    final datePart = date.split('T')[0];
    final timePart = time.replaceAll(' AM', ':00').replaceAll(' PM', ':00');

    return '${datePart}T${timePart}';
  }

  Future saveEvent(EventModel newEvent, File? pictureFile) async {
    emit(state.copyWith(status: Status.loading));

    // to cover default values (when user doesnt )
    var category = state.category != '' ? state.category : newEvent.category;
    var hourEnd = state.hourEnd != '' ? state.hourEnd : newEvent.hourEnd;
    var hourStart = state.hourStart != '' ? state.hourStart : newEvent.hourStart;

    EventModel adjustedEvent = newEvent.copyWith(
        id: state.eventId,
        dateEnd: mergeDataTime(state.dateEnd!, hourEnd!),
        dateStart: mergeDataTime(state.dateStart!, hourStart!),
        category: category,
        avatarUrl: state.imageUrl);

    print('...adjustedEvent:');
    print(adjustedEvent);

    emit(state.copyWith(status: Status.initial));

    var result = state.isUpdate == false
        ? await createEventUsecase(event: adjustedEvent, imageCover: pictureFile)
        : await updateEventUsecase(event: adjustedEvent, imageCover: pictureFile);

    result.fold(
      (failure) {
        emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
      },
      (noResponse) {
        emit(state.copyWith(
            status: Status.success, successMessage: state.isUpdate == false ? 'Event created' : 'Event updated', newEvent: adjustedEvent));
      },
    );
  }

  updateDates(String dateStart, String hourStart, String dateEnd, String hourEnd, String category) {
    if (dateStart != '') emit(state.copyWith(dateStart: dateStart));
    if (hourStart != '') emit(state.copyWith(hourStart: hourStart));

    if (dateEnd != '') emit(state.copyWith(dateEnd: dateEnd));
    if (hourEnd != '') emit(state.copyWith(hourEnd: hourEnd));
    if (category != '') emit(state.copyWith(category: category));

    print('...BLOC dateStart=${state.dateStart} hourStart=${state.hourStart}');
    print('...BLOC dateEnd=${state.dateEnd} hourEnd=${state.hourEnd}');
    print('...BLOC category=${state.category} ');
  }
}
