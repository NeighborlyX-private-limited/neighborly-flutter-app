import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/signup_with_email_usecase.dart';

part 'register_with_email_event.dart';
part 'register_with_email_state.dart';

class RegisterWithEmailBloc
    extends Bloc<RegisterWithEmailEvent, RegisterWithEmailState> {
  final SignupWithEmailUsecase _registerUser;

  RegisterWithEmailBloc({required SignupWithEmailUsecase registerUseCase})
      : _registerUser = registerUseCase,
        super(RegisterInitialState()) {
    on<RegisterButtonPressedEvent>((RegisterButtonPressedEvent event,
        Emitter<RegisterWithEmailState> emit) async {
      emit(RegisterLoadingState());

      final result = await _registerUser.call(
        event.email,
        event.password,
        // event.dob,
        // event.gender,
      );

      result.fold(
          (error) => emit(RegisterFailureState(error: error.toString())),
          (user) => emit(RegisterSuccessState()));
    });
  }
}
