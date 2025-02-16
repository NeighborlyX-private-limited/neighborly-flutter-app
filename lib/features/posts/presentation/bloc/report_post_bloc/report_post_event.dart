part of 'report_post_bloc.dart';

abstract class ReportPostEvent extends Equatable {}

class ReportButtonPressedEvent extends ReportPostEvent {
  final String postId;
  final String reason;
  final String type;
  ReportButtonPressedEvent({
    required this.postId,
    required this.type,
    required this.reason,
  });

  @override
  List<Object?> get props => [postId, reason];
}
