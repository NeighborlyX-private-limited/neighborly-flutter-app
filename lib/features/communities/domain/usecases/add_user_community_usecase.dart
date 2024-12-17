import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class AddUserCommunityUsecase {
  final CommunityRepositories repository;

  AddUserCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String userId,
  }) async {
    return await repository.joinGroup(
      communityId: communityId,
      userId: userId,
    );
  }
}
