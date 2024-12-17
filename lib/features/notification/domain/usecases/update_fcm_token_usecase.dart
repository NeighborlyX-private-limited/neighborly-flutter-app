import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/notification_repositories.dart';

class UpdateFCMTokenUsecase {
  final NotificationRepositories repository;

  UpdateFCMTokenUsecase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.updateFCMtoken();
  }
}
