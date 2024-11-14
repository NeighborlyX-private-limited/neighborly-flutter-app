import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/fogot_password_usecase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUsecase _forgotPasswordUsecase;

  ForgotPasswordBloc({required ForgotPasswordUsecase forgotPasswordUsecase})
      : _forgotPasswordUsecase = forgotPasswordUsecase,
        super(ForgotPasswordInitialState()) {
    ///ForgotPasswordButtonPressedEvent
    on<ForgotPasswordButtonPressedEvent>(
        (ForgotPasswordButtonPressedEvent event,
            Emitter<ForgotPasswordState> emit) async {
      emit(ForgotPasswordLoadingState());

      final result = await _forgotPasswordUsecase.call(event.email);
      print('...Result in ForgotPasswordBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(ForgotPasswordFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(ForgotPasswordSuccessState(message: response));
      });
    });
  }
}
