import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class MakeAdminCommunityUsecase {
  final CommunityRepositories repository;

  MakeAdminCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String userId,
  }) async {
    return await repository.makeAdmin(
      communityId: communityId,
      userId: userId,
    );
  }
}
