import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class DeleteCommunityUsecase {
  final CommunityRepositories repository;

  DeleteCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
  }) async {
    return await repository.deleteCommunity(
      communityId: communityId,
    );
  }
}
