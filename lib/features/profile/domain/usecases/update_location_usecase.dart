import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class UpdateLocationUsecase {
  final ProfileRepositories repository;

  UpdateLocationUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required Map<String,List<num>> location,
  }) async {
    return await repository.updateLocation(location: location);
  }
}
