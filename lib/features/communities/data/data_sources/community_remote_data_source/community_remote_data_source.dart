import 'dart:io';

import '../../../../../core/models/community_model.dart';
import '../../model/search_dash_model.dart';
import '../../model/search_result_model.dart';

abstract class CommunityRemoteDataSource {
  ///createCommunity
  Future<String> createCommunity({
    required CommunityModel community,
    File? pictureFile,
  });

  ///getAllCommunities
  Future<List<CommunityModel>> getAllCommunities({
    required bool isSummary,
    required bool isNearBy,
  });

  ///get community details
  Future<CommunityModel> getCommunity({
    required String communityId,
  });

  Future<void> removeUser(
      {required String communityId, required String userId});
  Future<void> makeAdmin({required String communityId, required String userId});

  Future<void> updateType(
      {required String communityId, required String newType});
  Future<void> updateDescription(
      {required String communityId, required String newDescription});
  Future<void> updateLocation(
      {required String communityId, required String newLocation});
  Future<void> updateRadius(
      {required String communityId, required num newRadius});
  Future<void> updateMute(
      {required String communityId, required bool newValue});
  Future<void> updateIcon(
      {required String communityId, File? pictureFile, String? imageUrl});

  Future<void> leaveCommunity({required String communityId});
  Future<void> reportCommunity(
      {required String communityId, required String reason});

  Future<SearchDashModel> getSearchHistoryAndTrends();
  Future<SearchResultModel> getSearchResults(
      {required String searchTem, required bool isPreview});
}
