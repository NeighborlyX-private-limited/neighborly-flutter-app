part of 'communities_main_cubit.dart';

class CommunityMainState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final List<CommunityModel> communities;

  const CommunityMainState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.communities = const [],
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
      ];

  CommunityMainState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    List<CommunityModel>? communities,
  }) {
    return CommunityMainState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      communities: communities ?? this.communities,
    );
  }
}
