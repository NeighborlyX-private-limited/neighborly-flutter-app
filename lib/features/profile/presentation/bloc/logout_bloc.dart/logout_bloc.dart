import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/logout_usecase.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUsecase _logoutUsecase;

  LogoutBloc({required LogoutUsecase logoutUsecase})
      : _logoutUsecase = logoutUsecase,
        super(LogoutInitialState()) {
    on<LogoutButtonPressedEvent>(
        (LogoutButtonPressedEvent event, Emitter<LogoutState> emit) async {
      emit(LogoutLoadingState());

      final result = await _logoutUsecase.call();
      result.fold((error) => emit(LogoutFailureState(error: error.toString())),
          (response) => emit(LogoutSuccessState()));
    });
  }
}
