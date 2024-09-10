import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UpdateRadiusCommunityUsecase {
  final CommunityRepositories repository;

  UpdateRadiusCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required num newRadius,
  }) async {
    return await repository.updateRadius(
        communityId: communityId, newRadius: newRadius);
  }
}
