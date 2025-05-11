abstract class WithdrawState {}

class WithdrawInitial extends WithdrawState {}

class WithdrawLoading extends WithdrawState {}

class WithdrawSuccess extends WithdrawState {
  final String message;
  WithdrawSuccess(this.message);
}

class WithdrawFailure extends WithdrawState {
  final String error;
  WithdrawFailure(this.error);
}
