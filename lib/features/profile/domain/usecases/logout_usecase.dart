import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class LogoutUsecase {
  final ProfileRepositories repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
