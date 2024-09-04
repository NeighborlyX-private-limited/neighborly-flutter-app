import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class VerifyOTPUsecase {
  final AuthRepository repository;

  VerifyOTPUsecase(this.repository);

  Future<Either<Failure, String>> call({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  }) async {
    return await repository.verifyOtp(
      email: email,
      phone: phone,
      otp: otp,
      verificationFor: verificationFor,
    );
  }
}
