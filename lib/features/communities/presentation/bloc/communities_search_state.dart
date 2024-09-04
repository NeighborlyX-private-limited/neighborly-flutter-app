part of 'communities_search_cubit.dart';

class CommunitySearchState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final String searchTerm;
  final SearchDashModel? dashData;
  final SearchResultModel? searchResult;

  final List<CommunityModel> communities;
  final List<UserSimpleModel> people;
  final List<String> histories;

  const CommunitySearchState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.searchTerm = '',
    this.dashData,
    this.searchResult,
    this.communities = const [],
    this.people = const [],
    this.histories = const [],
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        dashData,
        searchResult,
        searchTerm,
        communities,
        people,
        histories,
      ];

  CommunitySearchState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    String? searchTerm,
    SearchDashModel? dashData,
    SearchResultModel? searchResult,
    List<CommunityModel>? communities,
    List<UserSimpleModel>? people,
    List<String>? histories,
  }) {
    return CommunitySearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      searchTerm: searchTerm ?? this.searchTerm,
      dashData: dashData ?? this.dashData,
      searchResult: searchResult ?? this.searchResult,
      communities: communities ?? this.communities,
      people: people ?? this.people,
      histories: histories ?? this.histories,
    );
  }
}
