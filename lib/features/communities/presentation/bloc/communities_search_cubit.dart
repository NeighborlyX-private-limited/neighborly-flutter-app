import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../data/model/search_dash_model.dart';
import '../../data/model/search_result_model.dart';
import '../../domain/usecases/get_search_history_communities_usecase.dart';
import '../../domain/usecases/get_search_results_communities_usecase.dart';

part 'communities_search_state.dart';

class CommunitySearchCubit extends Cubit<CommunitySearchState> {
  final GetSearchHistoryCommunitiesUsecase getSearchHistoryCommunitiesUsecase;
  final GetSearchResultsCommunitiesUsecase getSearchResultsCommunitiesUsecase;

  CommunitySearchCubit(
    this.getSearchHistoryCommunitiesUsecase,
    this.getSearchResultsCommunitiesUsecase,
  ) : super(const CommunitySearchState());

  void init() async {
    await getSearchDashboard();
  }

  Future getSearchDashboard() async {
    emit(state.copyWith(status: Status.loading, searchTerm: ''));
    final result = await getSearchHistoryCommunitiesUsecase();

    result.fold(
      (failure) {
        print('... BLOC SEARCH failure: ${failure.message}');
        emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
      },
      (dashData) {
        // print('... BLOC SEARCH dash: $dashData');
        emit(state.copyWith(status: Status.success, dashData: dashData, histories: [...dashData.history.map((e) => e.term).toList()] ));
      },
    );
  }

  Future getSearchResult(String searchTerm, bool isPreview) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getSearchResultsCommunitiesUsecase(searchTerm: searchTerm, isPreview: isPreview);

    result.fold(
      (failure) {
        // print('... BLOC SEARCH failure: ${failure.message}');

        emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
      },
      (searchresult) {
        // print('... BLOC SEARCH results: dashData');
        emit(state.copyWith(status: Status.success, searchResult: searchresult));
      },
    );
  }

  void deleteHistoryTerm(String toDeleteTerm) {
    print('... BLOC deleteHistoryTerm toDeleteTerm=$toDeleteTerm');
    
    emit(state.copyWith(histories: [...state.histories.where((element) => element != toDeleteTerm)]));
  }

  // ignore: body_might_complete_norminqueuey_nullable
  FutureOr<List<dynamic>?> suggestionCallback(String searchStr) async {
    print('CUBIT suggestionCinqueueback searchStr=${searchStr} ');
    if (searchStr == "") return <dynamic>[];
    var response = <dynamic>[];

    await Future.delayed(Duration(seconds: 1));

    final result = await getSearchResultsCommunitiesUsecase(searchTerm: searchStr, isPreview: true);

    // print('..RESPONSE: ${response}');

    result.fold(
      (failure) {
        print('...ERROR ${failure.message}');
      },
      (searchResultes) {
        print('..RESPONSE: ${searchResultes}');
        response = [...searchResultes.communities, ...searchResultes.people];
      },
    );

    return response;
  }

  void cleanSearchTerm() {
    print('... BLOC cleanSearchTerm');
    emit(state.copyWith(searchTerm: ''));
  }

  Future getSearchResultBySumit(String searchTerm) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getSearchResultsCommunitiesUsecase(searchTerm: searchTerm, isPreview: false);

    result.fold(
      (failure) {
        print('... BLOC SEARCH failure: ${failure.message}');

        emit(state.copyWith(status: Status.failure, failure: failure, errorMessage: failure.message));
      },
      (searchresult) {
        print('... BLOC SEARCH results: people: ${searchresult.people}');
        emit(state.copyWith(
          status: Status.success,
          searchTerm: searchTerm,
          searchResult: searchresult,
          communities: [...searchresult.communities],
          people: [...searchresult.people],
        ));
      },
    );
  }
}
