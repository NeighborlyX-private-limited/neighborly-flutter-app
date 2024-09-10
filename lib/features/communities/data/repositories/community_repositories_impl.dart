import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/community_repositories.dart';
import '../data_sources/community_remote_data_source/community_remote_data_source.dart';
import '../model/search_dash_model.dart';
import '../model/search_result_model.dart';

class CommunityRepositoriesImpl implements CommunityRepositories {
  final CommunityRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CommunityRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CommunityModel>>> getAllCommunities(
      {required bool isSummary, required bool isNearBy}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllCommunities(
            isSummary: isSummary, isNearBy: isNearBy);
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
  Future<Either<Failure, CommunityModel>> getCommunity(
      {required String communityId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCommunity(
          communityId: communityId,
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
  Future<Either<Failure, void>> makeAdmin(
      {required String communityId, required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.makeAdmin(
            communityId: communityId, userId: userId);
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
  Future<Either<Failure, void>> removeUser(
      {required String communityId, required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeUser(
            communityId: communityId, userId: userId);
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
  Future<Either<Failure, void>> unblockUser(
      {required String communityId, required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeUser(
            communityId: communityId, userId: userId);
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
  Future<Either<Failure, void>> updateType(
      {required String communityId, required String newType}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateType(
            communityId: communityId, newType: newType);
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
  Future<Either<Failure, String>> createCommunity(
      {required CommunityModel community, File? pictureFile}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createCommunity(
            community: community, pictureFile: pictureFile);
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
  Future<Either<Failure, void>> leaveCommunity(
      {required String communityId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await remoteDataSource.leaveCommunity(communityId: communityId);
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
  Future<Either<Failure, void>> reportCommunity(
      {required String communityId, required String reason}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.reportCommunity(
            communityId: communityId, reason: reason);
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
  Future<Either<Failure, void>> updateDescription(
      {required String communityId, required String newDescription}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateDescription(
            communityId: communityId, newDescription: newDescription);
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
  Future<Either<Failure, void>> updateIcon(
      {required String communityId,
      File? pictureFile,
      String? imageUrl}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateIcon(
          communityId: communityId,
          pictureFile: pictureFile,
          imageUrl: imageUrl,
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
  Future<Either<Failure, void>> updateLocation(
      {required String communityId, required String newLocation}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateLocation(
            communityId: communityId, newLocation: newLocation);
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
  Future<Either<Failure, void>> updateMute(
      {required String communityId, required bool newValue}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateMute(
            communityId: communityId, newValue: newValue);
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
  Future<Either<Failure, void>> updateRadius(
      {required String communityId, required num newRadius}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateRadius(
            communityId: communityId, newRadius: newRadius);
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
  Future<Either<Failure, SearchDashModel>> getSearchHistoryAndTrends() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSearchHistoryAndTrends();
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
  Future<Either<Failure, SearchResultModel>> getSearchResults(
      {required String searchTem, required bool isPreview}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSearchResults(
            searchTem: searchTem, isPreview: isPreview);
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
