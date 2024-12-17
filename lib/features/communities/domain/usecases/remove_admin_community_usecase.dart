import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class RemoveAdminCommunityUsecase {
  final CommunityRepositories repository;

  RemoveAdminCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String userId,
  }) async {
    return await repository.removeAdmin(
      communityId: communityId,
      userId: userId,
    );
  }
}
