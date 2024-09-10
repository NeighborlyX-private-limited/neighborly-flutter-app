import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../data/model/search_dash_model.dart';
import '../../data/model/search_result_model.dart';

abstract class CommunityRepositories {
  Future<Either<Failure, List<CommunityModel>>> getAllCommunities(
      {required bool isSummary, required bool isNearBy});
  Future<Either<Failure, CommunityModel>> getCommunity(
      {required String communityId});

  Future<Either<Failure, void>> makeAdmin(
      {required String communityId, required String userId});
  Future<Either<Failure, void>> removeUser(
      {required String communityId, required String userId});
  Future<Either<Failure, void>> unblockUser(
      {required String communityId, required String userId});

  Future<Either<Failure, void>> updateType(
      {required String communityId, required String newType});
  Future<Either<Failure, void>> updateDescription(
      {required String communityId, required String newDescription});
  Future<Either<Failure, void>> updateLocation(
      {required String communityId, required String newLocation});
  Future<Either<Failure, void>> updateRadius(
      {required String communityId, required num newRadius});
  Future<Either<Failure, void>> updateMute(
      {required String communityId, required bool newValue});
  Future<Either<Failure, void>> updateIcon(
      {required String communityId, File? pictureFile, String? imageUrl});

  Future<Either<Failure, void>> leaveCommunity({required String communityId});
  Future<Either<Failure, void>> reportCommunity(
      {required String communityId, required String reason});

  Future<Either<Failure, String>> createCommunity(
      {required CommunityModel community, File? pictureFile});

  Future<Either<Failure, SearchDashModel>> getSearchHistoryAndTrends();
  Future<Either<Failure, SearchResultModel>> getSearchResults(
      {required String searchTem, required bool isPreview});
}
