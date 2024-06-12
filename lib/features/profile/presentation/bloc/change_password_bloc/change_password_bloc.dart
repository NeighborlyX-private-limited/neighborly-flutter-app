import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/change_password_usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUsecase _changePasswordUsecase;

  ChangePasswordBloc({required ChangePasswordUsecase changePasswordUsecase})
      : _changePasswordUsecase = changePasswordUsecase,
        super(ChangePasswordInitialState()) {
    on<ChangePasswordButtonPressedEvent>(
        (ChangePasswordButtonPressedEvent event,
            Emitter<ChangePasswordState> emit) async {
      emit(ChangePasswordLoadingState());

      final result = await _changePasswordUsecase.call(
          email: event.email,
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
          flag: event.flag);

      result.fold(
          (error) => emit(ChangePasswordFailureState(error: error.toString())),
          (response) => emit(ChangePasswordSuccessState(message: response)));
    });
  }
}
