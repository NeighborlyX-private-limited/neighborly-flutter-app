import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/communities/domain/repositories/community_repositories.dart';

class UpdateDisplayNameCommunityUsecase {
  final CommunityRepositories repository;

  UpdateDisplayNameCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String newDisplayname,
  }) async {
    return await repository.updateDisplayName(
      communityId: communityId,
      newDisplayname: newDisplayname,
    );
  }
}
