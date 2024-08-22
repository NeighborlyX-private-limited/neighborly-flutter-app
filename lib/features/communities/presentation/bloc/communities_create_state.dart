part of 'communities_create_cubit.dart';

class CommunityCreateState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final CommunityModel communitiyDraft;
  final File? imageToUpload;
  final String? imageUrl;
  final String newCommunityId;
  final bool? uploadIsLoading;

  const CommunityCreateState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.newCommunityId = '',
    this.imageUrl = '',
    this.imageToUpload,
    this.communitiyDraft = const CommunityModel(
      id: '',
      name: '',
      description: '',
      locationStr: '',
      createdAt: '',
      avatarUrl: 'https://eu.ui-avatars.com/api/?name=XX&background=random&rounded=true',
      karma: 0,
      membersCount: 0,
      isPublic: false,
      isJoined: true,
      isMuted: false,
      users: [],
      admins: [],
      blockList: [],
    ),
    this.uploadIsLoading = false,
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        imageToUpload,
        newCommunityId,
        imageUrl,
        uploadIsLoading
      ];

  CommunityCreateState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    CommunityModel? communitiyDraft,
    File? imageToUpload,
    String? newCommunityId,
    String? imageUrl,
    bool? uploadIsLoading,
  }) {
    return CommunityCreateState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      communitiyDraft: communitiyDraft ?? this.communitiyDraft,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      newCommunityId: newCommunityId ?? this.newCommunityId,
      imageUrl: imageUrl ?? this.imageUrl,
      uploadIsLoading: uploadIsLoading ?? this.uploadIsLoading,
    );
  }
}
