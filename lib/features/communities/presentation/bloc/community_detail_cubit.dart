import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/delete_community_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/update_community_displayname.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../domain/usecases/get_community_usecase.dart';
import '../../domain/usecases/report_community_usecase.dart';
import '../../domain/usecases/update_description_community_usecase.dart';
import '../../domain/usecases/update_icon_community_usecase.dart';
import '../../domain/usecases/update_location_community_usecase.dart';
import '../../domain/usecases/update_radius_community_usecase.dart';
import '../../domain/usecases/update_type_community_usecase.dart';
part 'community_detail_state.dart';

class CommunityDetailsCubit extends Cubit<CommunityDetailsState> {
  final GetCommunityUsecase getCommunityUsecase;
  final UpdateDisplayNameCommunityUsecase updateDisplayNameCommunityUsecase;
  final UpdateDescriptionCommunityUsecase updateDescriptionCommunityUsecase;
  final UpdateTypeCommunityUsecase updateTypeCommunityUsecase;
  final UpdateIconCommunityUsecase updateIconCommunityUsecase;
  final UpdateLocationCommunityUsecase updateLocationCommunityUsecase;
  final UpdateRadiusCommunityUsecase updateRadiusCommunityUsecase;
  final ReportCommunityUsecase reportCommunityUsecase;
  final DeleteCommunityUsecase deleteCommunityUsecase;

  CommunityDetailsCubit(
    this.getCommunityUsecase,
    this.updateDisplayNameCommunityUsecase,
    this.updateDescriptionCommunityUsecase,
    this.updateTypeCommunityUsecase,
    this.updateIconCommunityUsecase,
    this.updateLocationCommunityUsecase,
    this.updateRadiusCommunityUsecase,
    this.deleteCommunityUsecase,
    this.reportCommunityUsecase,
  ) : super(const CommunityDetailsState());

  /// get Community Detail
  Future getCommunityDetail(String communityId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getCommunityUsecase(communityId: communityId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (community) {
        emit(
          state.copyWith(
            status: Status.success,
            community: community,
          ),
        );
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

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
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

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
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

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (communityResp) {
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

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        emit(
          state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(description: newDescription),
          ),
        );
      },
    );
  }

  ///update updateDisplayName cubit
  Future updateDisplayName(String communityId, String newDisplayname) async {
    emit(state.copyWith(status: Status.loading));

    final result = await updateDisplayNameCommunityUsecase(
      communityId: communityId,
      newDisplayname: newDisplayname,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        emit(
          state.copyWith(
            status: Status.success,
            community: state.community!.copyWith(description: newDisplayname),
          ),
        );
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

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
        emit(state.copyWith(status: Status.success));
        getCommunityDetail(communityId);
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

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityResp) {
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

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (communityDelete) {
        emit(state.copyWith(status: Status.success));
      },
    );
  }
}
