import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class JoinCommunityUsecase {
  final CommunityRepositories repository;

  JoinCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String? userId,
  }) async {
    return await repository.joinGroup(
      communityId: communityId,
      userId: userId,
    );
  }
}
