part of 'delete_account_bloc.dart';

abstract class DeleteAccountEvent extends Equatable {}

class DeleteAccountButtonPressedEvent extends DeleteAccountEvent {
  DeleteAccountButtonPressedEvent();

  @override
  List<Object?> get props => [];
}
