import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/repositories/auth_repository.dart';

class ResendOTPUsecase {
  final AuthRepository repository;

  ResendOTPUsecase(this.repository);

  Future<Either<Failure, String>> call({
    String? email,
    String? phone,
  }) async {
    return await repository.resendOtp(
      email: email,
      phone: phone,
    );
  }
}
