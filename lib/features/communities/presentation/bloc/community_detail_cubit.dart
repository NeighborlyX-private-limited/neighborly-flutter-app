import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/delete_community_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/update_community_displayname.dart';
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
  final UpdateDisplayNameCommunityUsecase updateDisplayNameCommunityUsecase;
  final UploadFileUsecase uploadFileUsecase;
  final DeleteCommunityUsecase deleteCommunityUsecase;

  CommunityDetailsCubit(
    this.getCommunityUsecase,
    this.deleteCommunityUsecase,
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
    this.updateDisplayNameCommunityUsecase,
  ) : super(const CommunityDetailsState());

  /// get Community Detail
  Future getCommunityDetail(String communityId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getCommunityUsecase(communityId: communityId);
    print('result in getCommunityDetail cubit: $result');

    result.fold(
      (failure) {
        print('failure in getCommunityDetail cubit=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (community) {
        print('community details=$community');
        emit(
          state.copyWith(
            status: Status.success,
            community: community,
          ),
        );
      },
    );
  }

  /// make admin
  Future makeAdmin(String communityId, String userId) async {
    emit(state.copyWith(status: Status.loading));

    print('...make admin cubit');
    print('communityId=$communityId userId=$userId');
    final result = await makeAdminCommunityUsecase(
      communityId: communityId,
      userId: userId,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (community) {
        print('...makeAdmin done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  /// remove user
  Future removeUSer(String communityId, String userId) async {
    emit(state.copyWith(status: Status.loading));

    print('removeUSer communityId=$communityId userId=$userId');
    final result = await removeUserCommunityUsecase(
      communityId: communityId,
      userId: userId,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (community) {
        print('...remover user done');
        emit(state.copyWith(
          status: Status.success,
        ));
      },
    );
  }

  /// get community post
  Future getCommunityPosts(String communityId) async {
    // emit(state.copyWith(status: Status.loading));
    final result = await getAllPostsUsecase(isHome: false);
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityPosts) {
        print('...communityPosts=$communityPosts');
        emit(state.copyWith(posts: communityPosts));
        emit(state.copyWith(status: Status.success, posts: communityPosts));
      },
    );
  }

  /// update type cubit
  Future updateType(String communityId, String newType) async {
    emit(state.copyWith(status: Status.loading));
    final result = await updateTypeCommunityUsecase(
      communityId: communityId,
      newType: newType,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        print('...updateType done');
        emit(
          state.copyWith(
            status: Status.success,
            community:
                state.community!.copyWith(isPublic: (newType == 'public')),
          ),
        );
      },
    );
  }

  /// update location cubit
  Future updateLocation(String communityId, String newLocationStr) async {
    emit(state.copyWith(status: Status.loading));

    final result = await updateLocationCommunityUsecase(
      communityId: communityId,
      newLocation: newLocationStr,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        print('...updateLocation done');
        emit(
          state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(locationStr: newLocationStr),
          ),
        );
      },
    );
  }

  ///update radius cubit
  Future updateRadius(String communityId, double newRadius) async {
    emit(state.copyWith(status: Status.loading));

    final result = await updateRadiusCommunityUsecase(
      communityId: communityId,
      newRadius: newRadius,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
        print('...updateRadius done');
        emit(
          state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(radius: newRadius),
          ),
        );
      },
    );
  }

  ///update description cubit
  Future updateDescription(String communityId, String newDescription) async {
    emit(state.copyWith(status: Status.loading));

    final result = await updateDescriptionCommunityUsecase(
      communityId: communityId,
      newDescription: newDescription,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        print('...updateDescription done');
        emit(
          state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(description: newDescription),
          ),
        );
      },
    );
  }

  ///update description cubit
  Future updateDisplayName(String communityId, String newDisplayname) async {
    emit(state.copyWith(status: Status.loading));

    final result = await updateDisplayNameCommunityUsecase(
      communityId: communityId,
      newDisplayname: newDisplayname,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        print('...update display name done');
        emit(
          state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(description: newDisplayname),
          ),
        );
      },
    );
  }

  ///on update file
  Future onUpdateFile(File fileToUpload) async {
    var result = await uploadFileUsecase(file: fileToUpload);
    print('result:$result');
    result.fold(
      (failure) {
        print('... onUpdateFile error: ${failure.message}');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (imageUrl) {
        print('... imageUrl=$imageUrl');
        emit(state.copyWith(imageToUpload: fileToUpload, imageUrl: imageUrl));
      },
    );
  }

  /// update icon
  Future updateIcon(String communityId, File? imageToUpload) async {
    emit(state.copyWith(status: Status.loading));
    final result = await updateIconCommunityUsecase(
      communityId: communityId,
      pictureFile: imageToUpload,
      //imageUrl: state.imageUrl,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        print('...updateIcon done');
        emit(state.copyWith(status: Status.success));
        getCommunityDetail(communityId);
      },
    );
  }

  /// leave community cubit
  Future leaveCommunity(String communityId, String userId) async {
    final result = await removeUserCommunityUsecase(
      communityId: communityId,
      userId: userId,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityPosts) {
        print('...leaveCommunity done');
        emit(state.copyWith(
          status: Status.success,
          successMessage: 'leave',
        ));
      },
    );
  }

  ///toggle munte
  Future toggleMute() async {
    emit(state.copyWith(status: Status.loading));
    final result = await updateMuteCommunityUsecase(
      communityId: state.community?.id ?? '',
      isMute: !state.community!.isMuted,
    );
    print('result:$result');
    result.fold(
      (failure) {
        print('...failure=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        print('...toggleMute done');
        emit(
          state.copyWith(
            status: Status.success,
            community:
                state.community!.copyWith(isMuted: !(state.community!.isMuted)),
          ),
        );
      },
    );
  }

  /// report community cubit
  Future reportCommunity(String reason) async {
    emit(state.copyWith(status: Status.loading));
    final result = await reportCommunityUsecase(
      communityId: state.community!.id,
      reason: reason,
    );
    print('result in reportCommunity cubit:$result');
    result.fold(
      (failure) {
        print('failure in reportCommunity cubit:$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        print('reportCommunity done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  /// delete community cubit
  Future deleteCommunity(String? communityId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await deleteCommunityUsecase(
      communityId: communityId!,
    );
    print('result in deleteCommunity cubit:$result');
    result.fold(
      (failure) {
        print('failure deleteCommunity:$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityDelete) {
        print('communityDelete done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  ///unblockUser
  Future updateBlock(
    String communityId,
    String userId,
    String isBlock,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await unblockUserCommunityUsecase(
      communityId: communityId,
      userId: userId,
      isBlock: isBlock,
    );
    print('result in updateBlock cubit: $result');

    result.fold(
      (failure) {
        print('...failure in updateBlock cubit=$failure');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (community) {
        print('...updateBlock done');
        emit(state.copyWith(status: Status.success));
      },
    );
  }
}
