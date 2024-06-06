import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/entities/auth_response_entity.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/repositories/auth_repository.dart';

class SignupUserUsecase {
  final AuthRepository repository;

  SignupUserUsecase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(
      String email, String password) async {
    final result = await repository.signupWithEmail(
      email: email,
      password: password,
    );
    return result;
  }
}
