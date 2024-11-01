// part of 'notification_list_cubit.dart';

// class NotificationListState extends Equatable {
//   final Status status;
//   final Failure? failure;
//   final String? errorMessage;
//   final int page;
//   final List<NotificationModel> notifications;

//   const NotificationListState({
//     this.status = Status.initial,
//     this.failure,
//     this.errorMessage = '',
//     this.page = 1,
//     this.notifications = const [],
//   });

//   @override
//   List<Object?> get props =>
//       [status, failure, errorMessage, notifications, page];

//   NotificationListState copyWith({
//     Status? status,
//     Failure? failure,
//     String? errorMessage,
//     int? page,
//     List<NotificationModel>? notifications,
//   }) {
//     return NotificationListState(
//         status: status ?? this.status,
//         failure: failure ?? this.failure,
//         errorMessage: errorMessage ?? this.errorMessage,
//         notifications: notifications ?? this.notifications,
//         page: page ?? this.page);
//   }
// }

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
