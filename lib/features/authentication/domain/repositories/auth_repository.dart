import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/auth_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> signup({
    String? email,
    String? password,
    String? phone,
  });

  Future<Either<Failure, AuthResponseEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, dynamic>> googleAuthentication();

  Future<Either<Failure, String>> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  });

  Future<Either<Failure, String>> resendOtp({
    String? email,
    String? phone,
  });
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  });
}
