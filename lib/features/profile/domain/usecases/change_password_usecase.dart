import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class ChangePasswordUsecase {
  final ProfileRepositories repository;

  ChangePasswordUsecase(this.repository);

  Future<Either<Failure, String>> call({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  }) async {
    return await repository.changePassword(
        newPassword: newPassword,
        email: email,
        flag: flag,
        currentPassword: currentPassword);
  }
}
