part of 'make_remove_admin_bloc.dart';

abstract class MakeRemoveAdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MakeRemoveAdminInitialState extends MakeRemoveAdminState {
  MakeRemoveAdminInitialState();
}

class MakeRemoveAdminLoadingState extends MakeRemoveAdminState {
  MakeRemoveAdminLoadingState();
}

class MakeAdminSuccessState extends MakeRemoveAdminState {
  MakeAdminSuccessState();
}

class RemoveAdminSuccessState extends MakeRemoveAdminState {
  RemoveAdminSuccessState();
}

class MakeRemoveAdminFailureState extends MakeRemoveAdminState {
  final String error;
  MakeRemoveAdminFailureState({required this.error});
}
