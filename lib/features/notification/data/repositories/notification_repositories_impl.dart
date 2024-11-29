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
        print('result in updateFCMtoken NotificationRepositoriesImpl: $result');

        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in updateFCMtoken NotificationRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in updateFCMtoken NotificationRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in updateFCMtoken NotificationRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getAllNotification(
      {String? page}) async {
    if (await networkInfo.isConnected) {
      try {
        List<NotificationModel> result =
            await remoteDataSource.getAllNotification(page: page);
        print(
            'result in getAllNotification NotificationRepositoriesImpl: $result');

        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getAllNotification NotificationRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getAllNotification NotificationRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('else error in getAllNotification NotificationRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
