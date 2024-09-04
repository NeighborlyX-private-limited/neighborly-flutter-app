import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(
    String? email,
    String? password,
    String? phone,
  ) async {
    return await repository.signup(
      email: email,
      password: password,
      phone: phone,
    );
  }
}
