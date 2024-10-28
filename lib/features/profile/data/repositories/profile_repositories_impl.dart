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
  Future<Either<Failure, String>> changePassword({
    String? currentPassword,
    required String newPassword,
    required String email,
    required bool flag,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          email: email,
          flag: flag,
        );
        print('result in changePassword ProfileRepositoriesImpl: $result');

        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in changePassword ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in changePassword ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in changePassword ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocation(
      {required Map<String, List<num>> location}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateLocation(location: location);
        // print('result in updateLocation ProfileRepositoriesImpl: $result');
        return const Right(null);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in updateLocation ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in updateLocation ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in updateLocation ProfileRepositoriesImpl');
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
        // print('result in getGenderAndDOB ProfileRepositoriesImpl: $result');
        return const Right(null);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getGenderAndDOB ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getGenderAndDOB ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getGenderAndDOB ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getProfile();
        print('result in getProfile ProfileRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getProfile ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getProfile ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getProfile ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
        //  print('result in logout ProfileRepositoriesImpl: $result');
        return const Right(null);
      } on ServerFailure catch (e) {
        print('Server Failure in logout ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in logout ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in logout ProfileRepositoriesImpl');
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
        print('result in getMyPosts ProfileRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getMyPosts ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getMyPosts ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getMyPosts ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendFeedback({required String feedback}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendFeedback(feedback: feedback);
        //  print('result in sendFeedback ProfileRepositoriesImpl: $result');
        return const Right(null);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in sendFeedback ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in sendFeedback ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in sendFeedback ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount();
        //  print('result in deleteAccount ProfileRepositoriesImpl: $result');
        return const Right(null);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in deleteAccounts ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in deleteAccount ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in deleteAccount ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> getUserInfo(
      {required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUserInfo(userId: userId);
        print('result in getUserInfo ProfileRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getUserInfo ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getUserInfo ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getUserInfo ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PostWithCommentsEntity>>> getMyComments(
      {String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyComments(userId: userId);
        print('result in getMyComments ProfileRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getMyComments ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getMyComments ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getMyComments ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List>> getMyGroups({String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyGroups(userId: userId);
        print('result in getMyGroups ProfileRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getMyGroups ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getMyGroups ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getMyGroups ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> editProfile({
    String? username,
    String? gender,
    String? bio,
    File? image,
    String? phoneNumber,
    bool? toggleFindMe,
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
        //  print('result in editProfile ProfileRepositoriesImpl: $result');
        return const Right(null);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in editProfile ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in editProfile ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in editProfile ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List>> getMyAwards() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyAwards();
        print('result in getMyAwards ProfileRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getMyAwards ProfileRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getMyAwards ProfileRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getMyAwards ProfileRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
