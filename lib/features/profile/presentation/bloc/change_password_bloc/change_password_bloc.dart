import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/change_password_usecase.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUsecase _changePasswordUsecase;

  ChangePasswordBloc({required ChangePasswordUsecase changePasswordUsecase})
      : _changePasswordUsecase = changePasswordUsecase,
        super(ChangePasswordInitialState()) {
    on<ChangePasswordButtonPressedEvent>((
      ChangePasswordButtonPressedEvent event,
      Emitter<ChangePasswordState> emit,
    ) async {
      emit(ChangePasswordLoadingState());

      final result = await _changePasswordUsecase.call(
        email: event.email,
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        flag: event.flag,
      );
      print('...Result in ChangePasswordBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(ChangePasswordFailureState(error: error.toString()));
      }, (response) {
        print('fold response: ${response.toString()}');
        emit(ChangePasswordSuccessState(message: response));
      });
    });
  }
}
