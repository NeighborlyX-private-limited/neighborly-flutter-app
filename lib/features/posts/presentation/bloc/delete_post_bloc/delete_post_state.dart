part of 'delete_post_bloc.dart';

abstract class DeletePostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeletePostInitialState extends DeletePostState {
  DeletePostInitialState();
}

class DeletePostLoadingState extends DeletePostState {
  DeletePostLoadingState();
}

class DeletePostSuccessState extends DeletePostState {
  DeletePostSuccessState();
}

class DeletePostFailureState extends DeletePostState {
  final String error;
  DeletePostFailureState({required this.error});
}
