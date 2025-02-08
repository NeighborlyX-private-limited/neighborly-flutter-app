import 'dart:io';
import '../../../../../core/models/post_model.dart';
import '../../models/auth_response_model.dart';
import '../../models/post_with_comments_model.dart';

abstract class ProfileRemoteDataSource {
  Future<String> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  });
  Future<void> updateLocation({
    required Map<String, List<num>> location,
  });
  Future<void> getGenderAndDOB({
    String? gender,
    String? dob,
  });
  Future<List<PostModel>> getMyPosts({
    String? userId,
  });
  Future<List<PostWithCommentsModel>> getMyComments({
    String? userId,
  });
  Future<List<dynamic>> getMyGroups({
    String? userId,
  });
  Future<List<dynamic>> getMyAwards();
  Future<void> sendFeedback({
    required String feedback,
  });
  Future<AuthResponseModel> getProfile();
  Future<AuthResponseModel> getUserInfo({
    required String userId,
  });
  Future<void> logout();
  Future<void> deleteAccount();
  Future<void> editProfile({
    String? username,
    String? gender,
    String? bio,
    File? image,
    String? phoneNumber,
    bool? toggleFindMe,
  });
}
