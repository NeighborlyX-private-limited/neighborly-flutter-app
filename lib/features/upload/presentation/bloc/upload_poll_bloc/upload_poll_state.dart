part of 'upload_poll_bloc.dart';

abstract class UploadPollState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadPollInitialState extends UploadPollState {
  UploadPollInitialState();
}

class UploadPollLoadingState extends UploadPollState {
  UploadPollLoadingState();
}

class UploadPollSuccessState extends UploadPollState {
  UploadPollSuccessState();
}

class UploadPollFailureState extends UploadPollState {
  final String error;
  UploadPollFailureState({required this.error});
}
