import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';

import '../repositories/community_repositories.dart';

class GetAllCommunitiesUsecase {
  final CommunityRepositories repository;

  GetAllCommunitiesUsecase(this.repository);

  Future<Either<Failure, List<CommunityModel>>> call({
    required bool isSummary,
     required bool isNearBy
  }) async {
    return await repository.getAllCommunities(
      isSummary: isSummary,
      isNearBy: isNearBy,
    );
  }
}
