import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/entities/auth_response_entity.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/entities/google_auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> signupWithEmail({
    required String email,
    required String password,
  });
  Future<Either<Failure, AuthResponseEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, dynamic>> googleAuthentication(BuildContext context);

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
