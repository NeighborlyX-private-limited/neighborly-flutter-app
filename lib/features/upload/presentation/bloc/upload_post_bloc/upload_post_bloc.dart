import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/upload_post_usecase.dart';
part 'upload_post_event.dart';
part 'upload_post_state.dart';

class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  final UploadPostUsecase _uploadPostUsecase;

  UploadPostBloc({required UploadPostUsecase uploadPostUsecase})
      : _uploadPostUsecase = uploadPostUsecase,
        super(UploadPostInitialState()) {
    on<UploadPostPressedEvent>(
      (
        UploadPostPressedEvent event,
        Emitter<UploadPostState> emit,
      ) async {
        emit(UploadPostLoadingState());

        final result = await _uploadPostUsecase.call(
          type: event.type,
          title: event.title,
          content: event.content,
          options: event.options,
          allowMultipleVotes: event.allowMultipleVotes,
          multimedia: event.multimedia,
          thumbnail: event.thumbnail,
          location: event.location,
          city: event.city,
        );

        result.fold(
          (error) {
            emit(UploadPostFailureState(error: error.toString()));
          },
          (user) {
            emit(UploadPostSuccessState());
          },
        );
      },
    );
  }
}
