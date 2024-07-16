import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/verify_otp_usecase.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOTPUsecase _verifyOTPUsecase;

  OtpBloc({required VerifyOTPUsecase verifyOTPUsecase})
      : _verifyOTPUsecase = verifyOTPUsecase,
        super(OtpIdle()) {
    on<OtpSubmitted>((OtpSubmitted event, Emitter<OtpState> emit) async {
      emit(OtpLoadInProgress());

      final result = await _verifyOTPUsecase.call(
        email: event.email,
        otp: event.otp,
        verificationFor: event.verificationFor,
        phone: event.phone,
      );

      result.fold((error) => emit(OtpLoadFailure(error: error.toString())),
          (response) => emit(OtpLoadSuccess(message: response)));
    });
  }
}
