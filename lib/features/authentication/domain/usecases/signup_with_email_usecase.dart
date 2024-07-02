import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

class SignupWithEmailUsecase {
  final AuthRepository repository;

  SignupWithEmailUsecase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(
    String email,
    String password,
  ) async {
    return await repository.signupWithEmail(
      email: email,
      password: password,
    );
  }
}
