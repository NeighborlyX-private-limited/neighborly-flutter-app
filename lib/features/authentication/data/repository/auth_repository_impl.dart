import 'package:dartz/dartz.dart';
import '../../../../core/entities/auth_response_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthResponseEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.loginWithEmail(
          email: email,
          password: password,
        );
        print('loginWithEmail result in auth repo impl: $result');

        return Right(result);
      } on ServerFailure catch (e) {
        print('Server Failure in auth repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in auth repo impl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> signup({
    String? email,
    String? password,
    String? phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.signup(
          email: email,
          password: password,
          phone: phone,
        );
        print('signup result in auth repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('Server Failure in auth repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in auth repo impl: $e');
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print('No Internet Connection');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({
    String? email,
    String? phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.resendOtp(
          email: email,
          phone: phone,
        );
        print('resendOtp result in auth repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('Server Failure in auth repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in auth repo impl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    String? email,
    required String otp,
    String? verificationFor,
    String? phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.verifyOtp(
          email: email,
          otp: otp,
          verificationFor: verificationFor,
          phone: phone,
        );
        print('verifyOtp result in auth repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('Server Failure in auth repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in auth repo impl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.forgotPassword(email: email);
        print('forgotPassword result in auth repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('Server Failure in auth repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in auth repo impl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> googleAuthentication() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.googleAuthentication();
        print('googleAuthentication result in auth repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('Server Failure in auth repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in auth repo impl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
