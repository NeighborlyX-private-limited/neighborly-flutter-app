import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

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
