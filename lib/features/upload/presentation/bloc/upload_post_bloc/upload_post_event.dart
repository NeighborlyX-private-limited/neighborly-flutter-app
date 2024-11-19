part of 'upload_post_bloc.dart';

abstract class UploadPostEvent extends Equatable {}

class UploadPostPressedEvent extends UploadPostEvent {
  final List<double> location;
  final String? content;
  final List<File>? multimedia;
  final String title;
  final String type;
  final String city;
  final List<dynamic>? options;
  final bool allowMultipleVotes;
  final File? thumbnail;

  UploadPostPressedEvent({
    required this.location,
    required this.title,
    this.content,
    required this.type,
    this.multimedia,
    this.thumbnail,
    required this.city,
    this.options,
    required this.allowMultipleVotes,
  });

  @override
  List<Object?> get props => [
        location,
        title,
        content,
        type,
        multimedia,
        allowMultipleVotes,
        city,
        options,
        thumbnail,
      ];
}
