import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/verify_otp_usecase.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({required VerifyOTPUsecase verifyOtpUseCase})
      : _verifyOtpUseCase = verifyOtpUseCase,
        super(OtpIdle()) {
    on<OtpSubmitted>(_otpHandler);
  }

  final VerifyOTPUsecase _verifyOtpUseCase;

  Future<void> _otpHandler(event, emit) async {
    emit(OtpLoadInProgress());
    final result = await _verifyOtpUseCase.call(
      event.email,
      event.otp,
    );

    result.fold(
      (error) => emit(OtpLoadFailure(error: error.message.toString())),
      (message) => emit(OtpLoadSuccess(message: message)),
    );
  }
}
