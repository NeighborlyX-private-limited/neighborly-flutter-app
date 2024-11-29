import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/notification/data/model/notification_model.dart';

enum Status { initial, loading, success, failure }

class NotificationListState {
  final Status status;
  final List<NotificationModel> notifications;
  final int page;
  final String errorMessage;
  final Failure? failure;

  const NotificationListState({
    this.status = Status.initial,
    this.notifications = const [],
    this.page = 1,
    this.errorMessage = '',
    this.failure,
  });

  NotificationListState copyWith({
    Status? status,
    List<NotificationModel>? notifications,
    int? page,
    String? errorMessage,
    Failure? failure,
  }) {
    return NotificationListState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }
}
