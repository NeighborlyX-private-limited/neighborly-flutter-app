part of 'upload_post_bloc.dart';

abstract class UploadPostEvent extends Equatable {}

class UploadPostPressedEvent extends UploadPostEvent {
  final String type;
  final String title;
  final String? content;
  final List<dynamic>? options;
  final bool allowMultipleVotes;
  final List<File>? multimedia;
  final File? thumbnail;
  final List<double> location;
  final String city;

  UploadPostPressedEvent({
    required this.type,
    required this.title,
    this.content,
    this.options,
    required this.allowMultipleVotes,
    this.multimedia,
    this.thumbnail,
    required this.location,
    required this.city,
  });

  @override
  List<Object?> get props => [
        type,
        title,
        content,
        options,
        allowMultipleVotes,
        multimedia,
        thumbnail,
        location,
        city,
      ];
}
