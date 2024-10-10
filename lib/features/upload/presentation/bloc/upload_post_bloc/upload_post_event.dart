part of 'upload_post_bloc.dart';

abstract class UploadPostEvent extends Equatable {}

class UploadPostPressedEvent extends UploadPostEvent {
  final List<double> location;
  final String? content;
  final File? multimedia;
  final String title;
  final String type;
  final String city;
  final List<dynamic>? options;
  final bool allowMultipleVotes;

  UploadPostPressedEvent({
    required this.location,
    required this.title,
    this.content,
    required this.type,
    this.multimedia,
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
      ];
}
