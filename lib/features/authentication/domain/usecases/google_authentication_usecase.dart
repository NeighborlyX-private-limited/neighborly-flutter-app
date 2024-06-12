import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/entities/google_auth_entity.dart';
import 'package:neighborly_flutter_app/features/authentication/domain/repositories/auth_repository.dart';

class GoogleAuthenticationUsecase {
  final AuthRepository repository;

  GoogleAuthenticationUsecase(this.repository);

  Future<Either<Failure, dynamic>> call(BuildContext context) async {
    print('GoogleAuthenticationButtonPressedEvent');
    return await repository.googleAuthentication(context);
  }
}
