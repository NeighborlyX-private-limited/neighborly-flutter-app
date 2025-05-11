import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_event.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/withdraw_state.dart';

import '../../domain/usecase/withdraw_usecase.dart';

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  final WithdrawUseCase withdrawUseCase;

  WithdrawBloc(this.withdrawUseCase) : super(WithdrawInitial()) {
    on<WithdrawRequested>(_onWithdrawRequested);
  }

  Future<void> _onWithdrawRequested(
    WithdrawRequested event,
    Emitter<WithdrawState> emit,
  ) async {
    emit(WithdrawLoading());
    try {
      final result = await withdrawUseCase.call(event.amount, event.upiId);

      emit(WithdrawSuccess(result));
    } catch (e) {
      emit(WithdrawFailure("Failed to load rewards"));
    }

    // result.fold(
    //   (failure) => emit(WithdrawFailure(failure.message)),
    //   (success) => emit(WithdrawSuccess('Withdraw request submitted!')),
    // );
  }
}
