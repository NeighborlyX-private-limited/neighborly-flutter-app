import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/notification_model.dart';
import '../../domain/usecases/get_all_notifications_usecase.dart';

part 'notification_list_state.dart';

class NotificationListCubit extends Cubit<NotificationListState> {
  final GetAllNotificationsUsecase getAllNotificationsUsecase;
  NotificationListCubit(
    this.getAllNotificationsUsecase,
  ) : super(const NotificationListState());

  void init() async {
    getNotifications();
  }

  Future getNotifications({String? page}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getAllNotificationsUsecase(page: page);

    result.fold(
      (failure) {
        print('BLOC getNotifications ERROR: ' + failure.message);
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (notificationsList) {
        emit(state.copyWith(
            status: Status.success, notifications: notificationsList));
      },
    );
  }

  // TODO: appoint the notification that were readed
  // Future createNotification(  NotificationModel newNotification, File? pictureFile ) async {
  //   emit(state.copyWith(status: Status.loading));
  //   final result = await createNotificationUsecase( community: newNotification);

  //   result.fold(
  //     (failure) {
  //       emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message  ));
  //     },
  //     (newNotificationId) {
  //       emit(state.copyWith(status: Status.success, newNotificationId: newNotificationId));
  //     },
  //   );
  // }
}
