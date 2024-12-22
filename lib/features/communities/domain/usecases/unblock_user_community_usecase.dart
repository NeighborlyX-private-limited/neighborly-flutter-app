import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UnblockUserCommunityUsecase {
  final CommunityRepositories repository;

  UnblockUserCommunityUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required String communityId,
    required String userId,
    required bool isBlock,
  }) async {
    return await repository.updateBlock(
      communityId: communityId,
      userId: userId,
      isBlock: isBlock,
    );
  }
}
