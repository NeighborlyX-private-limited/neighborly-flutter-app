import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/core/network/network_info.dart';
import 'package:neighborly_flutter_app/features/profile/data/data_sources/profile_remote_data_source/profile_remote_data_source.dart';
import 'package:neighborly_flutter_app/features/profile/domain/repositories/profile_repositories.dart';

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
        print('Entered in repositories');
        final result = await remoteDataSource.changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            email: email,
            flag: flag);
        print('Result: $result');
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
