import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class DeleteAccountUsecase {
  final ProfileRepositories repository;

  DeleteAccountUsecase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAccount();
  }
}
