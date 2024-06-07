import 'package:neighborly_flutter_app/features/authentication/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signupWithEmail({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<String> verifyOtp({
    required String email,
    required String otp,
  });

  Future<String> resendOtp({required String email});
  Future<String> forgotPassword({required String email});
}
