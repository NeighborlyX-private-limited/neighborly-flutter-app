import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> signupWithEmail({
    required String email,
    required String password,
    // required String dob,
    // required String gender,
  });
  Future<Either<Failure, AuthResponseEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, dynamic>> googleAuthentication();

  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
    required String verificationFor,
  });

  Future<Either<Failure, String>> resendOtp({required String email});
  Future<Either<Failure, String>> forgotPassword({required String email});

  Future<Either<Failure, void>> logout(
      // {
      // required UserEntity userEntity,
      // }
      );
}
