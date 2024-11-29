import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/update_fcm_token_usecase.dart';
part 'notification_general_state.dart';

class NotificationGeneralCubit extends Cubit<NotificationGeneralState> {
  final UpdateFCMTokenUsecase updateFCMTokenUsecase;
  NotificationGeneralCubit(
    this.updateFCMTokenUsecase,
  ) : super(const NotificationGeneralState());

  void init() async {}

  Future<Either<Failure, String>> updateFCMtoken() async {
    return await updateFCMTokenUsecase();
  }

  Future<void> updateFCMtokenWithReturn() async {
    final result = await updateFCMTokenUsecase();
    print('...Result in NotificationGeneralCubit $result');

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
        return '';
      },
      (currentFCMtoken) {
        print('fold currentFCMtoken: ${currentFCMtoken.toString()}');
        emit(
          state.copyWith(
            status: Status.success,
            currentFCMtoken: currentFCMtoken,
          ),
        );
        return currentFCMtoken;
      },
    );
  }

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
