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
  Future<void> getUserInfo({
    String? gender,
    String? dob,
  });

  Future<AuthResponseModel> getProfile();
  Future<void> logout();
}
