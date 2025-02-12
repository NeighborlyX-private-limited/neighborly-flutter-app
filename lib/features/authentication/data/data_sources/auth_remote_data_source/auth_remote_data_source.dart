import '../../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  // EMAIL AND PHONE SIGNUP
  Future<AuthResponseModel> signup({
    String? email,
    String? password,
    String? phone,
  });
// LOGIN WITH EMAIL
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  });
  // SEND OTP FOR EMAIL AND PHONE
  Future<String> resendOtp({
    String? email,
    String? phone,
  });
  // VERIFY OTP FOR EMAIL AND PHONE
  Future<String> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  });
//FORGOT PASSWORD
  Future<String> forgotPassword({
    required String email,
  });
  // GOOGLE LOGIN
  Future<dynamic> googleAuthentication();
}
