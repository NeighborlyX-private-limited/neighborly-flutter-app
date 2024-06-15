part of 'upload_file_bloc.dart';

abstract class UploadFileEvent extends Equatable {}

class UploadFilePressedEvent extends UploadFileEvent {
  final File file;

  UploadFilePressedEvent({required this.file});

  @override
  List<Object?> get props => [file];
}
