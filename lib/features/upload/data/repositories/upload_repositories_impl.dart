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

  @override
  Future<Either<Failure, void>> uploadPost({
    required String title,
    String? content,
    required String type,
    List<File>? multimedia,
    required String city,
    List<dynamic>? options,
    required List<double> location,
    required bool allowMultipleVotes,
    File? thumbnail,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.uploadPost(
          title: title,
          content: content,
          type: type,
          multimedia: multimedia,
          allowMultipleVotes: allowMultipleVotes,
          city: city,
          options: options,
          location: location,
          thumbnail: thumbnail,
        );

        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in uploadPost UploadRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in uploadPost UploadRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in uploadPost uploadPost');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile({required File file}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.uploadFile(file: file);
        print('result in uploadPost UploadRepositoriesImpl: $result');

        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in uploadFile UploadRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in uploadFile UploadRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in uploadFile uploadPost');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
