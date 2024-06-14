part of 'upload_post_bloc.dart';

abstract class UploadPostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadPostInitialState extends UploadPostState {
  UploadPostInitialState();
}

class UploadPostLoadingState extends UploadPostState {
  UploadPostLoadingState();
}

class UploadPostSuccessState extends UploadPostState {
  UploadPostSuccessState();
}

class UploadPostFailureState extends UploadPostState {
  final String error;
  UploadPostFailureState({required this.error});
}
