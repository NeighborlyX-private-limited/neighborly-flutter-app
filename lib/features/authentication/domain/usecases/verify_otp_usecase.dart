import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/repositories/auth_repository.dart';

class VerifyOTPUsecase {
  final AuthRepository repository;

  VerifyOTPUsecase(this.repository);

  Future<Either<Failure, String>> call(
      String email, String otp) async {
    return await repository.verifyOtp(
      email: email, otp: otp,
      
    );
  }
}
