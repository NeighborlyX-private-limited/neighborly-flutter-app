part of 'notification_list_cubit.dart';

class NotificationListState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final List<NotificationModel> notifications;

  const NotificationListState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.notifications = const [],
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        notifications,
      ];

  NotificationListState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    List<NotificationModel>? notifications,
  }) {
    return NotificationListState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      notifications: notifications ?? this.notifications,
    );
  }
}
