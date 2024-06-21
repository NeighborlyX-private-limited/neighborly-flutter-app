import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class UpdateLocationUsecase {
  final ProfileRepositories repository;

  UpdateLocationUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required List<num> location,
  }) async {
    return await repository.updateLocation(location: location);
  }
}
