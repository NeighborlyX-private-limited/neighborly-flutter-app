part of 'delete_account_bloc.dart';

abstract class DeleteAccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteAccountInitialState extends DeleteAccountState {
  DeleteAccountInitialState();
}

class DeleteAccountLoadingState extends DeleteAccountState {
  DeleteAccountLoadingState();
}

class DeleteAccountSuccessState extends DeleteAccountState {
  DeleteAccountSuccessState();
}

class DeleteAccountFailureState extends DeleteAccountState {
  final String error;
  DeleteAccountFailureState({required this.error});
}
