import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UpdateDescriptionCommunityUsecase {
  final CommunityRepositories repository;

  UpdateDescriptionCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    required String newDescription,
  }) async {
    return await repository.updateDescription(
      communityId: communityId,
      newDescription: newDescription,
    );
  }
}
