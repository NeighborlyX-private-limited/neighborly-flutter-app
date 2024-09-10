import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/notification_repositories.dart';
import '../data_sources/notification_remote_data_source/notification_remote_data_source.dart';
import '../model/notification_model.dart';

class NotificationRepositoriesImpl implements NotificationRepositories {
  final NotificationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotificationRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> updateFCMtoken() async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.updateFCMtoken();
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
  Future<Either<Failure, List<NotificationModel>>> getAllNotification(
      {String? page}) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getAllNotification(page: page);
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
