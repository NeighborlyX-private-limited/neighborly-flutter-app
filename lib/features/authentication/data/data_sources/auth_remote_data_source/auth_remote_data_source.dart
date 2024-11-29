import '../../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signup({
    String? email,
    String? password,
    String? phone,
  });

  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<String> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  });

  Future<String> resendOtp({
    String? email,
    String? phone,
  });
  Future<String> forgotPassword({
    required String email,
  });
  Future<dynamic> googleAuthentication();
}
