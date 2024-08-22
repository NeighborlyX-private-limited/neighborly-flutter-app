import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class ReportCommunityUsecase {
  final CommunityRepositories repository;

  ReportCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String reason,
  }) async {
    return await repository.reportCommunity(communityId: communityId, reason: reason);
  }
}
