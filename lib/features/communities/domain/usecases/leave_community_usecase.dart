import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class LeaveCommunityUsecase {
  final CommunityRepositories repository;

  LeaveCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId, 
  }) async {
    return await repository.leaveCommunity(
      communityId: communityId,
    );
  }
}
