import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../data/model/search_dash_model.dart';
import '../../data/model/search_result_model.dart';

abstract class CommunityRepositories {
  ///create community repo
  Future<Either<Failure, String>> createCommunity({
    required CommunityModel community,
    File? pictureFile,
  });

  ///get all communities
  Future<Either<Failure, List<CommunityModel>>> getAllCommunities();

  ///get user groups
  Future<Either<Failure, List<CommunityModel>>> getUserGroups();

  ///get community details
  Future<Either<Failure, CommunityModel>> getCommunity({
    required String communityId,
  });

  ///make admin
  Future<Either<Failure, void>> makeAdmin({
    required String communityId,
    required String userId,
  });

  ///remove admin
  Future<Either<Failure, void>> removeAdmin({
    required String communityId,
    required String userId,
  });

  ///joinGroup
  Future<Either<Failure, void>> joinGroup({
    required String communityId,
    required String? userId,
  });

  ///leaveCommunity
  Future<Either<Failure, void>> leaveCommunity({
    required String communityId,
    required String? userId,
  });

  ///updateDisplayName
  Future<Either<Failure, void>> updateDisplayName({
    required String communityId,
    required String newDisplayname,
  });

  ///update description
  Future<Either<Failure, void>> updateDescription({
    required String communityId,
    required String newDescription,
  });

  ///update type
  Future<Either<Failure, void>> updateType({
    required String communityId,
    required String newType,
  });

  ///update icon
  Future<Either<Failure, void>> updateIcon({
    required String communityId,
    File? pictureFile,
  });

  ///update location
  Future<Either<Failure, void>> updateLocation({
    required String communityId,
    required String newLocation,
  });

  ///update radius
  Future<Either<Failure, void>> updateRadius({
    required String communityId,
    required num newRadius,
  });

  ///update mute
  Future<Either<Failure, void>> updateMute({
    required String communityId,
    required bool isMute,
  });

  ///report group
  Future<Either<Failure, void>> reportCommunity({
    required String communityId,
    required String reason,
  });

  ///delete group
  Future<Either<Failure, void>> deleteCommunity({
    required String communityId,
  });

  ///updateBlock user
  Future<Either<Failure, String>> updateBlock({
    required String communityId,
    required String userId,
    required bool isBlock,
  });

  Future<Either<Failure, SearchDashModel>> getSearchHistoryAndTrends();
  Future<Either<Failure, SearchResultModel>> getSearchResults({
    required String searchTem,
    required bool isPreview,
  });
}
