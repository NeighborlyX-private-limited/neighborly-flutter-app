import '../../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signupWithEmail({
    required String email,
    required String password,
    required String dob,
    required String gender,
  });

  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<String> verifyOtp({
    required String email,
    required String otp,
    required String verificationFor,
  });

  Future<dynamic> googleAuthentication();

  Future<String> resendOtp({required String email});
  Future<String> forgotPassword({required String email});
}
