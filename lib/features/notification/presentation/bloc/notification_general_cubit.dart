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

  Future<Either<Failure, String>> updateFCMtoken() async {
    return await updateFCMTokenUsecase();
  }

  Future<void> updateFCMtokenWithReturn() async {
    final result = await updateFCMTokenUsecase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (currentFCMtoken) {
        emit(
          state.copyWith(
            status: Status.success,
            currentFCMtoken: currentFCMtoken,
          ),
        );
      },
    );
  }
}
