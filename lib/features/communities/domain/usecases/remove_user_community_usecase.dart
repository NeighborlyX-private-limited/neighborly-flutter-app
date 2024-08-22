import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class RemoveUserCommunityUsecase {
  final CommunityRepositories repository;

  RemoveUserCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String userId,
  }) async {
    return await repository.removeUser(
      communityId: communityId,
      userId: userId,
    );
  }
}
