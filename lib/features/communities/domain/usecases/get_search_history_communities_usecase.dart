import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/search_dash_model.dart';
import '../repositories/community_repositories.dart';

class GetSearchHistoryCommunitiesUsecase {
  final CommunityRepositories repository;

  GetSearchHistoryCommunitiesUsecase(this.repository);

  Future<Either<Failure, SearchDashModel>> call() async {
    return await repository.getSearchHistoryAndTrends();
  }
}
