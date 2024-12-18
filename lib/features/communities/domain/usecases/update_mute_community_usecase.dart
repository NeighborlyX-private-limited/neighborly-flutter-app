import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UpdateMuteCommunityUsecase {
  final CommunityRepositories repository;

  UpdateMuteCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required bool isMute,
  }) async {
    return await repository.updateMute(
      communityId: communityId,
      isMute: isMute,
    );
  }
}
