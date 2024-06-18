import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/upload/domain/usecases/upload_poll_usecase.dart';

part 'upload_poll_event.dart';
part 'upload_poll_state.dart';

class UploadPollBloc extends Bloc<UploadPollEvent, UploadPollState> {
  final UploadPollUsecase _uploadPollUsecase;

  UploadPollBloc({required UploadPollUsecase uploadPollUsecase})
      : _uploadPollUsecase = uploadPollUsecase,
        super(UploadPollInitialState()) {
    on<UploadPollPressedEvent>(
        (UploadPollPressedEvent event, Emitter<UploadPollState> emit) async {
      emit(UploadPollLoadingState());

      final result = await _uploadPollUsecase.call(
        question: event.question,
        options: event.options,
      );

      result.fold(
          (error) => emit(UploadPollFailureState(error: error.toString())),
          (user) => emit(UploadPollSuccessState()));
    });
  }
}
