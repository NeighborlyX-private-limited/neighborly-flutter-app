import 'package:bloc/bloc.dart';
import 'package:neighborly_flutter_app/features/notification/data/model/notification_model.dart';
import 'package:neighborly_flutter_app/features/notification/domain/usecases/get_all_notifications_usecase.dart';
import 'notification_list_state.dart';

class NotificationListCubit extends Cubit<NotificationListState> {
  final GetAllNotificationsUsecase getAllNotificationsUsecase;
  bool hasMoreNotifications = true;

  NotificationListCubit(this.getAllNotificationsUsecase)
      : super(const NotificationListState());

  void init() {
    fetchOlderNotification();
  }

  Future<void> fetchOlderNotification() async {
    if (!hasMoreNotifications) return;
    emit(state.copyWith(status: Status.loading));
    try {
      final result =
          await getAllNotificationsUsecase(page: state.page.toString());
      result.fold(
        (failure) {
          emit(state.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.message));
        },
        (notificationsList) {
          if (notificationsList.isEmpty) {
            hasMoreNotifications = false;
            List<NotificationModel> updatedNotifications = [
              ...state.notifications,
              ...notificationsList
            ];
            emit(state.copyWith(
                status: Status.success,
                page: state.page + 1,
                notifications: updatedNotifications));
          } else {
            List<NotificationModel> updatedNotifications = [
              ...state.notifications,
              ...notificationsList
            ];
            emit(state.copyWith(
                status: Status.success,
                page: state.page + 1,
                notifications: updatedNotifications));
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'Error fetching notifications.',
        ),
      );
    }
  }

  void setPagetoDefault() {
    emit(state.copyWith(page: 1, notifications: []));
    hasMoreNotifications = true;
  }
}
