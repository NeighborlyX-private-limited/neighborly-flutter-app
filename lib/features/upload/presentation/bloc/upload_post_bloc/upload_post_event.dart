part of 'upload_post_bloc.dart';

abstract class UploadPostEvent extends Equatable {}

class UploadPostPressedEvent extends UploadPostEvent {
  final String content;
  String? multimedia;
  final List<num> location;

  UploadPostPressedEvent({
    required this.content,
    this.multimedia,
    required this.location,
  });

  @override
  List<Object?> get props => [
        content,
        multimedia,
        location,
      ];
}
