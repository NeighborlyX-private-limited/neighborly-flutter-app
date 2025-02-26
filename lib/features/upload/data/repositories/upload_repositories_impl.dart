import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/upload_repositories.dart';
import '../data_sources/upload_remote_data_source/upload_remote_data_source.dart';

class UploadRepositoriesImpl implements UploadRepositories {
  final UploadRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UploadRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  // UPLOAD POST
  @override
  Future<Either<Failure, void>> uploadPost({
    required String type,
    required String title,
    String? content,
    List<dynamic>? options,
    required bool allowMultipleVotes,
    List<File>? multimedia,
    File? thumbnail,
    required List<double> location,
    required String city,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.uploadPost(
          type: type,
          title: title,
          content: content,
          options: options,
          allowMultipleVotes: allowMultipleVotes,
          thumbnail: thumbnail,
          multimedia: multimedia,
          location: location,
          city: city,
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

  // UPLOAD FILE
  @override
  Future<Either<Failure, String>> uploadFile({required File file}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.uploadFile(file: file);

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
