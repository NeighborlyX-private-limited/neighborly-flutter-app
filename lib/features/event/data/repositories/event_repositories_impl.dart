import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/event_repositories.dart';
import '../data_sources/event_remote_data_source/event_remote_data_source.dart';
import '../model/event_model.dart';

class EventRepositoriesImpl implements EventRepositories {
  final EventRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EventRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EventModel>>> getEvents({
    required String scope,
    required String myOrOngoing,
    required String searchTerm,
    required String filterDateStart,
    required String filterDateEnd,
    required String filterCategory,
    required String filterLocation,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getEvents(
          scope: scope,
          myOrOngoing: myOrOngoing,
          searchTerm: searchTerm,
          filterDateStart: filterDateStart,
          filterDateEnd: filterDateEnd,
          filterCategory: filterCategory,
          filterLocation: filterLocation,
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
  Future<Either<Failure, void>> cancelEvent({required EventModel event, String? reason}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.cancelEvent(event: event, reason: reason);
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
  Future<Either<Failure, void>> createEvent({required EventModel event, File? imageCover}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createEvent(event: event, imageCover: imageCover);
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
  Future<Either<Failure, void>> joinEvent({required EventModel event}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.joinEvent(event: event);
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
  Future<Either<Failure, void>> updateEvent({required EventModel event, File? imageCover}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateEvent(event: event, imageCover: imageCover);
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
