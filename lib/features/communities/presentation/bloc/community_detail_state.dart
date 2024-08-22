part of 'community_detail_cubit.dart';

class CommunityDetailsState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final CommunityModel? community;
  final List<PostEntity> posts;
  final File? imageToUpload;
  final String? imageUrl;

  const CommunityDetailsState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.imageUrl = '',
    this.community,
    this.posts = const [],
    this.imageToUpload,
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        community,
        posts,
        imageToUpload,
        imageUrl,
      ];

  CommunityDetailsState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    CommunityModel? community,
    List<PostEntity>? posts,
    File? imageToUpload,
    String? imageUrl,
  }) {
    return CommunityDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      community: community ?? this.community,
      posts: posts ?? this.posts,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
