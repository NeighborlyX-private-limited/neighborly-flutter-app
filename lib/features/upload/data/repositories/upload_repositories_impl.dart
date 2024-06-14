import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/core/network/network_info.dart';

import 'package:neighborly_flutter_app/features/upload/data/data_sources/upload_remote_data_source/upload_remote_data_source.dart';
import 'package:neighborly_flutter_app/features/upload/domain/repositories/upload_repositories.dart';

class UploadRepositoriesImpl implements UploadRepositories {
  final UploadRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UploadRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> uploadPost(
      {String? content,
      String? title,
      String? multimedia,
      required List<num> location}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.uploadPost(
          content: content,
          title: title,
          multimedia: multimedia,
          location: location,
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
}
