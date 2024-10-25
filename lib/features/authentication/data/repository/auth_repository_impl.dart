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
  Future<Either<Failure, AuthResponseEntity>> loginWithEmail(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.loginWithEmail(
            email: email, password: password);

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
  Future<Either<Failure, String>> resendOtp({
    String? email,
    String? phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await remoteDataSource.resendOtp(email: email, phone: phone);
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
  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.forgotPassword(email: email);
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
  Future<Either<Failure, dynamic>> googleAuthentication() async {
    if (await networkInfo.isConnected) {
      try {
        print('GoogleAuthenticationButtonPressedEvent in repository');
        final result = await remoteDataSource.googleAuthentication();
        print('GoogleAuthenticationButtonPressedEvent success');
        print(result);
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
