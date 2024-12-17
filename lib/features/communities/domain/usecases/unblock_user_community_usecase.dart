import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UnblockUserCommunityUsecase {
  final CommunityRepositories repository;

  UnblockUserCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String userId,
  }) async {
    return await repository.unblockUser(
      communityId: communityId,
      userId: userId,
    );
  }
}
