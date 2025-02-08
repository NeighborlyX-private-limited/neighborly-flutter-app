part of 'community_detail_cubit.dart';

class CommunityDetailsState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final String? successMessage;
  final CommunityModel? community;
  final List<PostEntity> posts;
  final File? imageToUpload;
  final String? imageUrl;
  final String? communityId;

  const CommunityDetailsState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.successMessage = '',
    this.imageUrl = '',
    this.community,
    this.posts = const [],
    this.imageToUpload,
    this.communityId = '',
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        successMessage,
        community,
        posts,
        imageToUpload,
        imageUrl,
        communityId,
      ];

  CommunityDetailsState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    String? successMessage,
    CommunityModel? community,
    List<PostEntity>? posts,
    File? imageToUpload,
    String? imageUrl,
    String? communityId,
  }) {
    return CommunityDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      community: community ?? this.community,
      posts: posts ?? this.posts,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      imageUrl: imageUrl ?? this.imageUrl,
      communityId: communityId ?? this.communityId,
    );
  }
}
