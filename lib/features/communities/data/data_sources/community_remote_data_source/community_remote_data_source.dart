import 'dart:io';
import '../../../../../core/models/community_model.dart';
import '../../model/search_dash_model.dart';
import '../../model/search_result_model.dart';

abstract class CommunityRemoteDataSource {
  ///create Community
  Future<String> createCommunity({
    required CommunityModel community,
    File? pictureFile,
  });

  ///get All Communities
  Future<List<CommunityModel>> getAllCommunities();

  ///get users groups
  Future<List<CommunityModel>> getUserGroups();

  ///get community details
  Future<CommunityModel> getCommunity({
    required String communityId,
  });

  ///make admin
  Future<void> makeAdmin({
    required String communityId,
    required String userId,
  });

  ///make admin
  Future<void> removeAdmin({
    required String communityId,
    required String userId,
  });

  ///add user in group
  Future<void> joinGroup({
    required String communityId,
    required String? userId,
  });

  ///leave group
  Future<void> leaveCommunity({
    required String communityId,
    required String? userId,
  });

  ///update group updateDisplayname
  Future<void> updateDisplayname({
    required String communityId,
    required String newDisplayname,
  });

  ///update group description
  Future<void> updateDescription({
    required String communityId,
    required String newDescription,
  });

  ///update group type
  Future<void> updateType({
    required String communityId,
    required String newType,
  });

  ///update group icon/image/avatar
  Future<void> updateIcon({
    required String communityId,
    File? pictureFile,
  });

  /// update group location
  Future<void> updateLocation({
    required String communityId,
    required String newLocation,
  });

  ///update group radius
  Future<void> updateRadius({
    required String communityId,
    required num newRadius,
  });

  ///update mute/unmute
  Future<void> updateMute({
    required String communityId,
    required bool isMute,
  });

  ///report group
  Future<void> reportCommunity({
    required String communityId,
    required String reason,
  });

  ///delete group
  Future<void> deleteCommunity({
    required String communityId,
  });

  ///update block
  Future<String> updateBlock({
    required String communityId,
    required String userId,
    required bool isBlock,
  });

  ///can be delete these fun
  Future<SearchDashModel> getSearchHistoryAndTrends();
  Future<SearchResultModel> getSearchResults({
    required String searchTem,
    required bool isPreview,
  });
}
