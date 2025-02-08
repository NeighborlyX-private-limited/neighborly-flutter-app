import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class LogoutUsecase {
  final ProfileRepositories repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
