import 'package:neighborly_flutter_app/core/models/post_model.dart';
import 'package:neighborly_flutter_app/features/profile/data/models/auth_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<String> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  });
  Future<void> updateLocation({
    required List<num> location,
  });
  Future<void> getGenderAndDOB({
    String? gender,
    String? dob,
  });
  Future<List<PostModel>> getMyPosts({
    String? userId,
  });
  Future<void> sendFeedback({
    required String feedback,
  });
  Future<AuthResponseModel> getProfile();
  Future<AuthResponseModel> getUserInfo({
    required String userId,
  });
  Future<void> logout();
  Future<void> deleteAccount();
}
