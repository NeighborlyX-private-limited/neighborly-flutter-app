import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/profile_repositories.dart';

class EditProfileUsecase {
  final ProfileRepositories repository;

  EditProfileUsecase(this.repository);

  Future<Either<Failure, void>> call(
      {String? username,
      String? gender,
      String? bio,
      File? image,
      String? phoneNumber,
      bool? toggleFindMe

      //  List<double> homeCoordinates,
      }) async {
    return await repository.editProfile(
        username: username,
        gender: gender,

        // homeCoordinates: homeCoordinates,
        bio: bio,
        phoneNumber: phoneNumber,
        toggleFindMe: toggleFindMe,
        image: image);
  }
}
