import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';

abstract class ProfileRepositories {
  Future<Either<Failure, String>> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  });
  Future<Either<Failure, void>> updateLocation({
    required List<num> location,
  });
  Future<Either<Failure, void>> getUserInfo({
    String? gender,
    String? dob,
  });

  
}
