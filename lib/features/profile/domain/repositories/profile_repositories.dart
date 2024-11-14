import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/entities/auth_response_entity.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_with_comments_entity.dart';

abstract class ProfileRepositories {
  Future<Either<Failure, String>> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  });
  Future<Either<Failure, void>> updateLocation({
    required Map<String, List<num>> location,
  });
  Future<Either<Failure, void>> getGenderAndDOB({
    String? gender,
    String? dob,
  });
  Future<Either<Failure, AuthResponseEntity>> getUserInfo({
    required String userId,
  });
  Future<Either<Failure, List<PostEntity>>> getMyPosts({
    String? userId,
  });
  Future<Either<Failure, List<PostWithCommentsEntity>>> getMyComments({
    String? userId,
  });
  Future<Either<Failure, List<dynamic>>> getMyGroups({
    String? userId,
  });
  Future<Either<Failure, void>> sendFeedback({
    required String feedback,
  });
  Future<Either<Failure, List<dynamic>>> getMyAwards();
  Future<Either<Failure, AuthResponseEntity>> getProfile();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> editProfile({
    String? username,
    String? gender,
    String? bio,
    File? image,
    String? phoneNumber,
    bool? toggleFindMe,
    // required List<double> homeCoordinates,
  });
}
