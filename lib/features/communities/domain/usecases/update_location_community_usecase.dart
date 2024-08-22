import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UpdateLocationCommunityUsecase {
  final CommunityRepositories repository;

  UpdateLocationCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String newLocation,
  }) async {
    return await repository.updateLocation(
      communityId: communityId,
      newLocation: newLocation,
    );
  }
}
