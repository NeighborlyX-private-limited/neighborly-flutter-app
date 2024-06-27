part of 'upload_post_bloc.dart';

abstract class UploadPostEvent extends Equatable {}

class UploadPostPressedEvent extends UploadPostEvent {
  final String? content;
  final String? multimedia;
  final List<num> location;
  final String title;
  final String type;
  final String city;

  UploadPostPressedEvent({
    required this.title,
    this.content,
    required this.type,
    this.multimedia,
    required this.location,
    required this.city,
  });

  @override
  List<Object?> get props => [
        title,
        content,
        type,
        multimedia,
        location,
      ];
}
