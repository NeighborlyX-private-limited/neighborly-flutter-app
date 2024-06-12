abstract class ProfileRemoteDataSource {
  Future<String> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  });
}