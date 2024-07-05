import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class GetGenderAndDOBUsecase {
  final ProfileRepositories repository;

  GetGenderAndDOBUsecase(this.repository);

  Future<Either<Failure, void>> call({
    String? gender,
    String? dob,
  }) async {
    return await repository.getGenderAndDOB(
      gender: gender,
      dob: dob,
    );
  }
}
