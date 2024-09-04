part of 'upload_file_bloc.dart';

abstract class UploadFileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadFileInitialState extends UploadFileState {
  UploadFileInitialState();
}

class UploadFileLoadingState extends UploadFileState {
  UploadFileLoadingState();
}

class UploadFileSuccessState extends UploadFileState {
  final String url;
  UploadFileSuccessState({
    required this.url,
  });
}

class UploadFileFailureState extends UploadFileState {
  final String error;
  UploadFileFailureState({required this.error});
}
