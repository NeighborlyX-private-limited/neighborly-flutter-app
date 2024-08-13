import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/signup_with_email_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignupUsecase _registerUser;

  RegisterBloc({required SignupUsecase registerUseCase})
      : _registerUser = registerUseCase,
        super(RegisterInitialState()) {
    on<RegisterButtonPressedEvent>(
        (RegisterButtonPressedEvent event, Emitter<RegisterState> emit) async {
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
  }
}
