import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/auth_response_entity.dart';

abstract class AuthRepository {
  // EMAIL AND PHONE SIGNUP
  Future<Either<Failure, AuthResponseEntity>> signup({
    String? email,
    String? password,
    String? phone,
  });
  // LOGIN WITH EMAIL
  Future<Either<Failure, AuthResponseEntity>> loginWithEmail({
    required String email,
    required String password,
  });
  // SEND OTP FOR EMAIL AND PHONE
  Future<Either<Failure, String>> resendOtp({
    String? email,
    String? phone,
  });
// VERIFY OTP  FOR EMAIL AND PHONE
  Future<Either<Failure, String>> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  });
// FORGOT PASSWORD
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  });
  // GOOGLE AUTH
  Future<Either<Failure, dynamic>> googleAuthentication();
}
