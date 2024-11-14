import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/delete_account_usecase.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUsecase _deleteAccountUsecase;
  DeleteAccountBloc({required DeleteAccountUsecase deleteAccountUsecase})
      : _deleteAccountUsecase = deleteAccountUsecase,
        super(DeleteAccountInitialState()) {
    on<DeleteAccountButtonPressedEvent>((
      DeleteAccountButtonPressedEvent event,
      Emitter<DeleteAccountState> emit,
    ) async {
      emit(DeleteAccountLoadingState());
      final result = await _deleteAccountUsecase();
      print('...Result in DeleteAccountBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(DeleteAccountFailureState(error: error.toString()));
      }, (response) {
        // print('fold response: ${response.toString()}');
        emit(DeleteAccountSuccessState());
      });
    });
  }
}
