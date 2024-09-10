import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../../posts/domain/usecases/get_all_posts_usecase.dart';
import '../../../upload/domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/get_community_usecase.dart';
import '../../domain/usecases/leave_community_usecase.dart';
import '../../domain/usecases/make_admin_community_usecase.dart';
import '../../domain/usecases/remove_user_community_usecase.dart';
import '../../domain/usecases/report_community_usecase.dart';
import '../../domain/usecases/unblock_user_community_usecase.dart';
import '../../domain/usecases/update_description_community_usecase.dart';
import '../../domain/usecases/update_icon_community_usecase.dart';
import '../../domain/usecases/update_location_community_usecase.dart';
import '../../domain/usecases/update_mute_community_usecase.dart';
import '../../domain/usecases/update_radius_community_usecase.dart';
import '../../domain/usecases/update_type_community_usecase.dart';

part 'community_detail_state.dart';

class CommunityDetailsCubit extends Cubit<CommunityDetailsState> {
  final GetCommunityUsecase getCommunityUsecase;
  final GetAllPostsUsecase getAllPostsUsecase;
  final MakeAdminCommunityUsecase makeAdminCommunityUsecase;
  final RemoveUserCommunityUsecase removeUserCommunityUsecase;
  final UnblockUserCommunityUsecase unblockUserCommunityUsecase;
  final UpdateTypeCommunityUsecase updateTypeCommunityUsecase;

  final UpdateLocationCommunityUsecase updateLocationCommunityUsecase;
  final UpdateRadiusCommunityUsecase updateRadiusCommunityUsecase;
  final LeaveCommunityUsecase leaveCommunityUsecase;
  final UpdateMuteCommunityUsecase updateMuteCommunityUsecase;
  final ReportCommunityUsecase reportCommunityUsecase;
  final UpdateIconCommunityUsecase updateIconCommunityUsecase;
  final UpdateDescriptionCommunityUsecase updateDescriptionCommunityUsecase;
  final UploadFileUsecase uploadFileUsecase;

  CommunityDetailsCubit(
    this.getCommunityUsecase,
    this.getAllPostsUsecase,
    this.makeAdminCommunityUsecase,
    this.removeUserCommunityUsecase,
    this.unblockUserCommunityUsecase,
    this.updateTypeCommunityUsecase,
    this.updateLocationCommunityUsecase,
    this.updateRadiusCommunityUsecase,
    this.leaveCommunityUsecase,
    this.reportCommunityUsecase,
    this.updateIconCommunityUsecase,
    this.updateDescriptionCommunityUsecase,
    this.updateMuteCommunityUsecase,
    this.uploadFileUsecase,
  ) : super(const CommunityDetailsState());

  void init(String communityId) async {
    print('... COMMUNITY DETAIL BLOC - init - id=${communityId}');

    await getCommunityDetail(communityId);
    await getCommunityPosts(communityId);
  }

  Future getCommunityDetail(String communityId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getCommunityUsecase(
        communityId: communityId); // unblockUserCommunityUsecase

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (community) {
        print('...community=${community}');
        emit(state.copyWith(status: Status.success, community: community));
      },
    );
  }

  Future unblockUser(String communityId, String userId) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT unblockUser communityId=${communityId} userId=${userId}');
    final result = await unblockUserCommunityUsecase(
        communityId: communityId, userId: userId);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (community) {
        print('...unblockUser done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  Future makeAdmin(String communityId, String userId) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT makeAdmin communityId=${communityId} userId=${userId}');
    final result = await makeAdminCommunityUsecase(
        communityId: communityId, userId: userId);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (community) {
        print('...makeAdmin done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  Future removeUSer(String communityId, String userId) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT removeUSer communityId=${communityId} userId=${userId}');
    final result = await removeUserCommunityUsecase(
        communityId: communityId, userId: userId);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (community) {
        print('...remover user done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  Future getCommunityPosts(String communityId) async {
    print('... BLOG getCommunityPosts started');
    // emit(state.copyWith(status: Status.loading));
    final result = await getAllPostsUsecase(isHome: false);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityPosts) {
        print('...communityPosts=${communityPosts}');
        emit(state.copyWith(posts: communityPosts));
        emit(state.copyWith(status: Status.success, posts: communityPosts));
      },
    );
  }

  // ####################################################################
  // ####################################################################

  Future updateType(String communityId, String newType) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT updateType communityId=${communityId} newType=${newType}');
    final result = await updateTypeCommunityUsecase(
        communityId: communityId, newType: newType);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...updateType done');
        emit(state.copyWith(
            status: Status.success,
            community:
                state.community!.copyWith(isPublic: (newType == 'public'))));
      },
    );
  }

  Future updateLocation(String communityId, String newLocationStr) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT updateLocation communityId=${communityId} newLocationStr=${newLocationStr}');
    final result = await updateLocationCommunityUsecase(
        communityId: communityId, newLocation: newLocationStr);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...updateLocation done');
        emit(state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(locationStr: newLocationStr)));
      },
    );
  }

  Future updateRadius(String communityId, double newRadius) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT updateRadius communityId=${communityId} newRadius=${newRadius}');
    final result = await updateRadiusCommunityUsecase(
        communityId: communityId, newRadius: newRadius);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...updateRadius done');
        emit(state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(radius: newRadius)));
      },
    );
  }

  Future updateDescription(String communityId, String newDescription) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT updateDescription communityId=${communityId} newDescription=${newDescription}');
    final result = await updateDescriptionCommunityUsecase(
        communityId: communityId, newDescription: newDescription);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...updateDescription done');
        emit(state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(description: newDescription)));
      },
    );
  }

  Future onUpdateFile(File fileToUpload) async {
    var result = await uploadFileUsecase(file: fileToUpload);

    print('...BLOC onUpdateFile start');

    result.fold(
      (failure) {
        print('...BLOC onUpdateFile error: ${failure.message}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (imageUrl) {
        print('... BLOC imageUrl=${imageUrl}');
        emit(state.copyWith(imageToUpload: fileToUpload, imageUrl: imageUrl));
      },
    );
  }

  Future updateIcon(String communityId, File? imageToUpload) async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT updateIcon communityId=${communityId} imageUrl=${state.imageUrl}');
    final result = await updateIconCommunityUsecase(
        communityId: communityId, pictureFile: null, imageUrl: state.imageUrl);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...updateIcon done');
        emit(state.copyWith(status: Status.success));
        // Refresh main data
        getCommunityDetail(communityId);
      },
    );
  }

  Future leaveCommunity() async {
    print('... BLOG leaveCommunity communityId=${state.community?.id}  ');
    final result =
        await leaveCommunityUsecase(communityId: state.community!.id);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityPosts) {
        print('...leaveCommunity done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  Future toggleMute() async {
    emit(state.copyWith(status: Status.loading));

    print(
        'COMMUNITY DETAIL CUBIT toggleMute isMuted=${state.community?.isMuted} ');
    final result = await updateMuteCommunityUsecase(
        communityId: state.community?.id ?? '',
        newValue: !state.community!.isMuted);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...toggleMute done');
        emit(state.copyWith(
            status: Status.success,
            community: state.community!
                .copyWith(isMuted: !(state.community!.isMuted))));
      },
    );
  }

  Future reportCommunity(String reason) async {
    emit(state.copyWith(status: Status.loading));

    print('...COMMUNITY DETAIL CUBIT reportCommunity reason=${reason} ');
    final result = await reportCommunityUsecase(
        communityId: state.community!.id, reason: reason);

    result.fold(
      (failure) {
        print('...failure=${failure}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...reportCommunity done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }
}
