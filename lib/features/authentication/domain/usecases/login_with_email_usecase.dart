import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

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
