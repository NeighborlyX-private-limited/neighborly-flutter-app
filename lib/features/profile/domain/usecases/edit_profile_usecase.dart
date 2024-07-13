import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

class EditProfileUsecase {
  final ProfileRepositories repository;

  EditProfileUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String username,
    required String gender,
    String? bio,
    File? image,
    // required List<double> homeCoordinates,
  }) async {
    return await repository.editProfile(
        username: username,
        gender: gender,
        // homeCoordinates: homeCoordinates,
        bio: bio,
        image: image);
  }
}
