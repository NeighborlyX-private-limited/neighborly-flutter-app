import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../repositories/community_repositories.dart';

class GetUserGroupsUsecase {
  final CommunityRepositories repository;
  GetUserGroupsUsecase(this.repository);

  Future<Either<Failure, List<CommunityModel>>> call() async {
    return await repository.getUserGroups();
  }
}
