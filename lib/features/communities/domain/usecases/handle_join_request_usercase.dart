import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class HandleJoinRequestUsercase {
  final CommunityRepositories repository;
  HandleJoinRequestUsercase(this.repository);

  Future<Either<Failure, String>> call({
    required String communityId,
    required String requestId,
    required String status,
  }) async {
    return await repository.handleJoinRequest(
      communityId: communityId,
      requestId: requestId,
      status: status,
    );
  }
}
