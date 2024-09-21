import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/signup_with_email_usecase.dart';
import '../../../../../core/entities/auth_response_entity.dart';
import '../../../domain/usecases/google_authentication_usecase.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc
    extends Bloc<RegisterEvent, RegisterState> {
  final SignupUsecase _registerUser;
  final GoogleAuthenticationUsecase _googleLogin;

  RegisterBloc(
      {required SignupUsecase registerUseCase,
      required GoogleAuthenticationUsecase googleLoginCase})
      : _googleLogin = googleLoginCase,
        _registerUser = registerUseCase,
        super(RegisterInitialState()) {
    on<RegisterButtonPressedEvent>((RegisterButtonPressedEvent event,
        Emitter<RegisterState> emit) async {
      emit(RegisterLoadingState());

      final result = await _registerUser.call(
        event.email,
        event.password,
        event.phone,
      );

      result.fold(
          (error) => emit(RegisterFailureState(error: error.toString())),
          (user) => emit(RegisterSuccessState()));
    });

    on<GoogleSignUpEvent>(
        (GoogleSignUpEvent event, Emitter<RegisterState> emit) async {
      emit(RegisterLoadingState());

      final result = await _googleLogin.call();
      result.fold((error) => emit(RegisterFailureState(error: error.toString())),
          (response) => emit(OAuthSuccessState(message: 'true')));
    });
  }
}
