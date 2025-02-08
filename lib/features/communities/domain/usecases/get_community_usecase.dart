import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../repositories/community_repositories.dart';

class GetCommunityUsecase {
  final CommunityRepositories repository;

  GetCommunityUsecase(this.repository);

  Future<Either<Failure, CommunityModel>> call({
    required String communityId,
  }) async {
    return await repository.getCommunity(
      communityId: communityId,
    );
  }
}
