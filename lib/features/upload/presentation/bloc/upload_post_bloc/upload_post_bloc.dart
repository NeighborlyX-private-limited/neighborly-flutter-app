import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/upload/domain/usecases/upload_post_usecase.dart';

part 'upload_post_event.dart';
part 'upload_post_state.dart';

class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  final UploadPostUsecase _uploadPostUsecase;

  UploadPostBloc({required UploadPostUsecase uploadPostUsecase})
      : _uploadPostUsecase = uploadPostUsecase,
        super(UploadPostInitialState()) {
    on<UploadPostPressedEvent>(
        (UploadPostPressedEvent event, Emitter<UploadPostState> emit) async {
      emit(UploadPostLoadingState());

      final result = await _uploadPostUsecase.call(
        title: event.title,
        content: event.content,
        type: event.type,
        multimedia: event.multimedia,
        city: event.city,
        allowMultipleVotes: event.allowMultipleVotes,
        options: event.options,
      );

      result.fold(
          (error) => emit(UploadPostFailureState(error: error.toString())),
          (user) => emit(UploadPostSuccessState()));
    });
  }
}
