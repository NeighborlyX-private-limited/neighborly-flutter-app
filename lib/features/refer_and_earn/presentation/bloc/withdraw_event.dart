abstract class WithdrawEvent {}

class WithdrawRequested extends WithdrawEvent {
  final int amount;
  final String upiId;

  WithdrawRequested({required this.amount, required this.upiId});
}
