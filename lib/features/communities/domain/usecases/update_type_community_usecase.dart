import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UpdateTypeCommunityUsecase {
  final CommunityRepositories repository;

  UpdateTypeCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String newType,
  }) async {
    return await repository.updateType(
      communityId: communityId,
      newType: newType,
    );
  }
}
