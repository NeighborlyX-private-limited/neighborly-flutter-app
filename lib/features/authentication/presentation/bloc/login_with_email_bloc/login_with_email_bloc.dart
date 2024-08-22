import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/auth_response_entity.dart';
import '../../../domain/usecases/login_with_email_usecase.dart';

part 'login_with_email_event.dart';
part 'login_with_email_state.dart';

class LoginWithEmailBloc extends Bloc<LoginWithEmailEvent, LoginWithEmailState> {
  final LoginWithEmailUsecase _loginUser;

  LoginWithEmailBloc({required LoginWithEmailUsecase loginUseCase})
      : _loginUser = loginUseCase,
        super(LoginInitialState()) {
    on<LoginButtonPressedEvent>((LoginButtonPressedEvent event,
        Emitter<LoginWithEmailState> emit) async {
      emit(LoginLoadingState());

      final result = await _loginUser.call(event.email, event.password);

      result.fold((error) => emit(LoginFailureState(error: error.toString())),
          (response) => emit(LoginSuccessState(authResponseEntity: response)));
    });
  }
}
