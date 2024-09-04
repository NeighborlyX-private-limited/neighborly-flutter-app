import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/report_post_usecase.dart';

part 'report_post_event.dart';
part 'report_post_state.dart';

class ReportPostBloc extends Bloc<ReportPostEvent, ReportPostState> {
  final ReportPostUsecase _reportPostUsecase;

  ReportPostBloc({required ReportPostUsecase reportPostUsecase})
      : _reportPostUsecase = reportPostUsecase,
        super(ReportPostInitialState()) {
    on<ReportButtonPressedEvent>(
        (ReportButtonPressedEvent event, Emitter<ReportPostState> emit) async {
      emit(ReportPostLoadingState());

      final result = await _reportPostUsecase.call(
          reason: event.reason, type: event.type, postId: event.postId);

      result.fold(
          (error) => emit(ReportPostFailureState(error: error.toString())),
          (response) => emit(ReportPostSuccessState()));
    });
  }
}
