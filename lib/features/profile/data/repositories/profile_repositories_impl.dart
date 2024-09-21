import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/entities/auth_response_entity.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/post_with_comments_entity.dart';
import '../../domain/repositories/profile_repositories.dart';
import '../data_sources/profile_remote_data_source/profile_remote_data_source.dart';

class ProfileRepositoriesImpl implements ProfileRepositories {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> changePassword(
      {String? currentPassword,
      required String newPassword,
      required String email,
      required bool flag}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            email: email,
            flag: flag);
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocation(
      {required Map<String,List<num>> location}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateLocation(location: location);
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> getGenderAndDOB(
      {String? gender, String? dob}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.getGenderAndDOB(
          gender: gender,
          dob: dob,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getProfile();
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getMyPosts({
    String? userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyPosts(
          userId: userId,
        );
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendFeedback({required String feedback}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendFeedback(feedback: feedback);
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount();
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> getUserInfo(
      {required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUserInfo(userId: userId);
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PostWithCommentsEntity>>> getMyComments(
      {String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyComments(userId: userId);
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List>> getMyGroups({String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyGroups(userId: userId);
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> editProfile(
      {String? username,
      String? gender,
      String? bio,
      File? image,
      String? phoneNumber,
      bool? toggleFindMe

      // required List<double> homeCoordinates,
      }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.editProfile(
          username: username,
          bio: bio,
          // homeCoordinates: homeCoordinates,
          image: image,
          phoneNumber: phoneNumber,
          toggleFindMe: toggleFindMe,
          gender: gender,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List>> getMyAwards() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyAwards();
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
