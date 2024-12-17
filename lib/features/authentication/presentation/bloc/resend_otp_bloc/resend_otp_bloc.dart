import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/resend_otp_usecase.dart';
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

      final result = await _resendOTPUsecase.call(
        email: event.email,
        phone: event.phone,
      );
      print('...Result in ResendOtpBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(ResendOTPFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(ResendOTPSuccessState(message: response));
      });
    });
  }
}
