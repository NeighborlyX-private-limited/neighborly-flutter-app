import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;

  ForgotPasswordUsecase(this.repository);

  Future<Either<Failure, String>> call(String email) async {
    return await repository.forgotPassword(
      email: email,
    );
  }
}
