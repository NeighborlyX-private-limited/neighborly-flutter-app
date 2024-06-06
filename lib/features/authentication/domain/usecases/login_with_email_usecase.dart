import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/entities/auth_response_entity.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/repositories/auth_repository.dart';

class LoginWithEmailUsecase {
  final AuthRepository repository;

  LoginWithEmailUsecase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(
      String email, String password) async {
    return await repository.loginWithEmail(
      email: email,
      password: password,
    );
  }
}
