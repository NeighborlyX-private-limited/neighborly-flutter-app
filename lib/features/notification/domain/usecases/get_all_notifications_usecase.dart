import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/notification_model.dart';
import '../repositories/notification_repositories.dart';

class GetAllNotificationsUsecase {
  final NotificationRepositories repository;

  GetAllNotificationsUsecase(this.repository);

  Future<Either<Failure, List<NotificationModel>>> call({String? page}) async {
    return await repository.getAllNotification(page: page);
  }
}
