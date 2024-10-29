import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/auth_response_entity.dart';
import '../../../domain/usecases/google_authentication_usecase.dart';
import '../../../domain/usecases/login_with_email_usecase.dart';

part 'login_with_email_event.dart';
part 'login_with_email_state.dart';

class LoginWithEmailBloc
    extends Bloc<LoginWithEmailEvent, LoginWithEmailState> {
  final LoginWithEmailUsecase _loginUser;
  final GoogleAuthenticationUsecase _googleLogin;

  LoginWithEmailBloc(
      {required LoginWithEmailUsecase loginUseCase,
      required GoogleAuthenticationUsecase googleLoginCase})
      : _googleLogin = googleLoginCase,
        _loginUser = loginUseCase,
        super(LoginInitialState()) {
    ///LoginButtonPressedEvent
    on<LoginButtonPressedEvent>((LoginButtonPressedEvent event,
        Emitter<LoginWithEmailState> emit) async {
      emit(LoginLoadingState());

      final result = await _loginUser.call(event.email, event.password);
      print('...Result in LoginWithEmailBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(LoginFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(LoginSuccessState(authResponseEntity: response));
      });
    });

    ///GoogleLoginEvent
    on<GoogleLoginEvent>((
      GoogleLoginEvent event,
      Emitter<LoginWithEmailState> emit,
    ) async {
      emit(LoginLoadingState());

      final result = await _googleLogin.call();
      print('...Result in GoogleLoginEvent $result');
      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(LoginFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(OAuthSuccessState(message: 'true'));
      });
    });
  }
}
