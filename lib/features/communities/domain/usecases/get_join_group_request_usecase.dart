import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../data/model/group_join_request_model.dart';
import '../repositories/community_repositories.dart';

class GetJoinGroupRequestUsecase {
  final CommunityRepositories repository;
  GetJoinGroupRequestUsecase(this.repository);

  Future<Either<Failure, List<GroupJoinRequestModel>>> call({
    required String communityId,
  }) async {
    // return <GroupJoinRequestModel>[];
    return await repository.getCommunityJoinRequest(communityId: communityId);
  }
}
