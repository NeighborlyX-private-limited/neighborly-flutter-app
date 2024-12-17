import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/search_result_model.dart';
import '../repositories/community_repositories.dart';

class GetSearchResultsCommunitiesUsecase {
  final CommunityRepositories repository;

  GetSearchResultsCommunitiesUsecase(this.repository);

  Future<Either<Failure, SearchResultModel>> call({
    required String searchTerm,
    required bool isPreview,
  }) async {
    return await repository.getSearchResults(
      searchTem: searchTerm,
      isPreview: isPreview,
    );
  }
}
