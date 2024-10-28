import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/notification_model.dart';

abstract class NotificationRepositories {
  Future<Either<Failure, List<NotificationModel>>> getAllNotification({
    String? page,
  });
  Future<Either<Failure, String>> updateFCMtoken();
}
