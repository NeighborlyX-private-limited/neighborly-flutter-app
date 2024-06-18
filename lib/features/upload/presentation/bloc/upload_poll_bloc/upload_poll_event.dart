part of 'upload_poll_bloc.dart';

abstract class UploadPollEvent extends Equatable {}

class UploadPollPressedEvent extends UploadPollEvent {
  final String question;
  final List<String> options;

  UploadPollPressedEvent({
    required this.question,
    required this.options,
  });

  @override
  List<Object?> get props => [
        question,
        options,
      ];
}
