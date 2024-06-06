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

  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String otp,
  });

  Future<AuthResponseModel> resendOtp({required String email});
}
