import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/fogot_password_usecase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUsecase _forgotPasswordUsecase;

  ForgotPasswordBloc({required ForgotPasswordUsecase forgotPasswordUsecase})
      : _forgotPasswordUsecase = forgotPasswordUsecase,
        super(ForgotPasswordInitialState()) {
    on<ForgotPasswordButtonPressedEvent>(
        (ForgotPasswordButtonPressedEvent event,
            Emitter<ForgotPasswordState> emit) async {
      emit(ForgotPasswordLoadingState());

      final result = await _forgotPasswordUsecase.call(event.email);

      result.fold(
          (error) => emit(ForgotPasswordFailureState(error: error.toString())),
          (response) => emit(ForgotPasswordSuccessState(message: response)));
    });
  }
}
