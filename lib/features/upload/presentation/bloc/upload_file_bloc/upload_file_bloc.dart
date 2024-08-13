import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/upload/domain/usecases/upload_file_usecase.dart';

part 'upload_file_event.dart';
part 'upload_file_state.dart';

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final UploadFileUsecase _uploadFileUsecase;

  UploadFileBloc({required UploadFileUsecase uploadFileUsecase})
      : _uploadFileUsecase = uploadFileUsecase,
        super(UploadFileInitialState()) {
    on<UploadFilePressedEvent>(
        (UploadFilePressedEvent event, Emitter<UploadFileState> emit) async {
      emit(UploadFileLoadingState());

      final result = await _uploadFileUsecase.call(
        file: event.file,
      );

      result.fold(
          (error) => emit(UploadFileFailureState(error: error.toString())),
          (url) => emit(UploadFileSuccessState(url: url)));
    });
  }
}
