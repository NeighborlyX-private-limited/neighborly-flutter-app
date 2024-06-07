import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/resend_otp_usecase.dart';

part 'resend_otp_event.dart';
part 'resend_otp_state.dart';

class ResendOtpBloc extends Bloc<ResendOTPEvent, ResendOTPState> {
  final ResendOTPUsecase _resendOTPUsecase;

  ResendOtpBloc({required ResendOTPUsecase resendOTPUsecase})
      : _resendOTPUsecase = resendOTPUsecase,
        super(ResendOTPInitialState()) {
    on<ResendOTPButtonPressedEvent>((ResendOTPButtonPressedEvent event,
        Emitter<ResendOTPState> emit) async {
      emit(ResendOTPLoadingState());

      final result = await _resendOTPUsecase.call(event.email);

      result.fold(
          (error) => emit(ResendOTPFailureState(error: error.toString())),
          (response) => emit(ResendOTPSuccessState(message: response)));
    });
  }
}
