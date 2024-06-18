part of 'report_post_bloc.dart';

abstract class ReportPostEvent extends Equatable {}

class ReportButtonPressedEvent extends ReportPostEvent {
  final num postId;
  final String reason;
  ReportButtonPressedEvent({required this.postId, required this.reason});

  @override
  List<Object?> get props => [postId, reason];
}
