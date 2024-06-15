import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/entities/google_auth_entity.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/usecases/google_authentication_usecase.dart';


part 'google_authentication_event.dart';
part 'google_authentication_state.dart';

class GoogleAuthenticationBloc
    extends Bloc<GoogleAuthenticationEvent, GoogleAuthenticationState> {
  final GoogleAuthenticationUsecase _googleAuthenticationUsecase;

  GoogleAuthenticationBloc(
      {required GoogleAuthenticationUsecase googleAuthenticationaUsecase})
      : _googleAuthenticationUsecase = googleAuthenticationaUsecase,
        super(GoogleAuthenticationInitialState()) {
    on<GoogleAuthenticationButtonPressedEvent>(_onGoogleAuthButtonPressed);
  }

  Future<void> _onGoogleAuthButtonPressed(
      GoogleAuthenticationButtonPressedEvent event,
      Emitter<GoogleAuthenticationState> emit) async {
    emit(GoogleAuthenticationLoadingState());

    // Assuming context is provided or initialized somewhere in your application
    // You need to pass the context from where this event is triggered
    try {
      final response = await _googleAuthenticationUsecase.call();

      response.fold(
          (failure) => emit(GoogleAuthenticationFailureState(
              error: _mapFailureToMessage(failure))),
          (googleAuthEntity) => emit(GoogleAuthenticationSuccessState(
              googleAuthEntity: googleAuthEntity)));
    } catch (e) {
      emit(GoogleAuthenticationFailureState(
          error: 'Unexpected error occurred: ${e.toString()}'));
    }
  }

  // Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure: ${failure.message}';
    } else {
      return 'Unexpected Error';
    }
  }
}
