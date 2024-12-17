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

  /// create community repo impl
  @override
  Future<Either<Failure, String>> createCommunity({
    required CommunityModel community,
    File? pictureFile,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createCommunity(
          community: community,
          pictureFile: pictureFile,
        );
        print('result in createCommunity repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('ServerFailure in createCommunity repo impl: ${e.toString()}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error in createCommunity repo impl : ${e.toString()}');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///get all communities repo impl
  @override
  Future<Either<Failure, List<CommunityModel>>> getAllCommunities() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllCommunities();
        print('result in getAllCommunities repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('ServerFailure in getAllCommunities repo impl: ${e.toString()}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error in getAllCommunities repo impl: ${e.toString()}');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///get community details usecase
  @override
  Future<Either<Failure, CommunityModel>> getCommunity({
    required String communityId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCommunity(
          communityId: communityId,
        );
        print('result in getCommunity repo impl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print('server failure in getCommunity repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error in getCommunity repo impl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///make admin repo impl
  @override
  Future<Either<Failure, void>> makeAdmin({
    required String communityId,
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.makeAdmin(
          communityId: communityId,
          userId: userId,
        );
        print('success result in makeAdmin repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in makeAdmin repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error in makeAdmin repo impl: ${e.toString()}');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///remove admin repo impl
  @override
  Future<Either<Failure, void>> removeAdmin({
    required String communityId,
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeAdmin(
          communityId: communityId,
          userId: userId,
        );
        print('success result in removeAdmin repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in removeAdmin repo impl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error in removeAdmin repo impl: ${e.toString()}');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///joinGroup repo impl
  @override
  Future<Either<Failure, void>> joinGroup({
    required String communityId,
    required String? userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.joinGroup(
          communityId: communityId,
          userId: userId,
        );
        print('success result in joinGroup repo impl');
        return const Right(null);
      } on ServerFailure catch (e) {
        print('failure in joinGroup repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error joinGroup in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  /// leaveCommunity repo impl
  @override
  Future<Either<Failure, void>> leaveCommunity({
    required String communityId,
    required String? userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.leaveCommunity(
          communityId: communityId,
          userId: userId,
        );
        print('success result in leaveCommunity repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in leaveCommunity repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error leaveCommunity in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///updateDisplayName repo impl
  @override
  Future<Either<Failure, void>> updateDisplayName({
    required String communityId,
    required String newDisplayname,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateDisplayname(
          communityId: communityId,
          newDisplayname: newDisplayname,
        );
        print('success result in updateDisplayName repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in updateDisplayName repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error updateDisplayName in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///update description repo impl
  @override
  Future<Either<Failure, void>> updateDescription({
    required String communityId,
    required String newDescription,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateDescription(
          communityId: communityId,
          newDescription: newDescription,
        );
        print('success result in updateDescription repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in updateDescription repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error updateDescription in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///update type repo impl
  @override
  Future<Either<Failure, void>> updateType({
    required String communityId,
    required String newType,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateType(
          communityId: communityId,
          newType: newType,
        );
        print('success result in updateType repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in updateType repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error updateType in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  /// update icon repo impl
  @override
  Future<Either<Failure, void>> updateIcon({
    required String communityId,
    File? pictureFile,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateIcon(
          communityId: communityId,
          pictureFile: pictureFile,
        );
        print('success result in updateIcon repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in updateIcon repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error updateIcon in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  /// update location repo impl
  @override
  Future<Either<Failure, void>> updateLocation({
    required String communityId,
    required String newLocation,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateLocation(
          communityId: communityId,
          newLocation: newLocation,
        );
        print('success result in updateLocation repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in updateLocation repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error updateLocation in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  /// update redius repo impl
  @override
  Future<Either<Failure, void>> updateRadius({
    required String communityId,
    required num newRadius,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateRadius(
          communityId: communityId,
          newRadius: newRadius,
        );
        print('success result in updateRadius repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in updateRadius repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error updateRadius in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  /// update mute repo impl
  @override
  Future<Either<Failure, void>> updateMute({
    required String communityId,
    required bool newValue,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateMute(
          communityId: communityId,
          newValue: newValue,
        );
        print('success result in updateMute repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in updateMute repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error updateMute in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///report community repo impl
  @override
  Future<Either<Failure, void>> reportCommunity({
    required String communityId,
    required String reason,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.reportCommunity(
          communityId: communityId,
          reason: reason,
        );
        print('success result in reportCommunity repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in reportCommunity repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error reportCommunity in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  /// deleteCommunity repo impl
  @override
  Future<Either<Failure, void>> deleteCommunity({
    required String communityId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteCommunity(
          communityId: communityId,
        );
        print('success result in deleteCommunity repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in deleteCommunity repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error deleteCommunity in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  /// unblock user repo impl
  @override
  Future<Either<Failure, void>> unblockUser({
    required String communityId,
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.leaveCommunity(
          communityId: communityId,
          userId: userId,
        );
        print('success result in unblockUser repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in unblockUser repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error unblockUser in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  ///getSearchHistoryAndTrends
  @override
  Future<Either<Failure, SearchDashModel>> getSearchHistoryAndTrends() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSearchHistoryAndTrends();
        print('success result in getSearchHistoryAndTrends repo impl');
        return Right(result);
      } on ServerFailure catch (e) {
        print('failure in getSearchHistoryAndTrends repo impl:${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch error getSearchHistoryAndTrends in repo impl $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SearchResultModel>> getSearchResults({
    required String searchTem,
    required bool isPreview,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSearchResults(
          searchTem: searchTem,
          isPreview: isPreview,
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
