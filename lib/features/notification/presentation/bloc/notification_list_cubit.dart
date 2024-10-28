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

    final result =
        await getAllNotificationsUsecase(page: state.page.toString());
    print('...Result in NotificationListCubit getNotifications: $result');

    result.fold(
      (failure) {
        print('fold failure: ${failure.toString()}');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (notificationsList) {
        print('fold notificationsList: ${notificationsList.toString()}');
        emit(
          state.copyWith(
            status: Status.success,
            page: state.page + 1,
            notifications: notificationsList,
          ),
        );
      },
    );
  }

  Future<void> fetchOlderNotification() async {
    try {
      final result =
          await getAllNotificationsUsecase(page: state.page.toString());
      print(
          '...Result in NotificationListCubit fetchOlderNotification: $result');
      result.fold(
        (failure) {
          print('fold failure: ${failure.toString()}');
          emit(
            state.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.message,
            ),
          );
        },
        (notificationsList) {
          print('fold notificationsList: ${notificationsList.toString()}');
          List<NotificationModel> olderMessages = state.notifications;
          final updatedMessages = [...notificationsList, ...olderMessages];
          emit(
            state.copyWith(
              status: Status.success,
              page: state.page + 1,
              notifications: updatedMessages,
            ),
          );
        },
      );
    } catch (e) {
      print(
          'Error fetching older messages in NotificationListCubit fetchOlderNotification: $e');
    }
  }

  void setPagetoDefault() {
    emit(state.copyWith(page: 1));
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
