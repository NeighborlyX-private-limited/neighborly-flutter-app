import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

import '../repositories/auth_repository.dart';

class GoogleAuthenticationUsecase {
  final AuthRepository repository;

  GoogleAuthenticationUsecase(this.repository);

  Future<Either<Failure, dynamic>> call() async {
    return await repository.googleAuthentication();
  }
}
