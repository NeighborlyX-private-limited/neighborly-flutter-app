import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';

abstract class EventRepositories {
  Future<Either<Failure, List<EventModel>>> getEvents({
    required String scope,
    required String myOrOngoing,
    required String searchTerm,
    required String filterDateStart,
    required String filterDateEnd,
    required String filterCategory,
    required String filterLocation,
  });

  Future<Either<Failure, void>> createEvent({required EventModel event, File? imageCover});
  Future<Either<Failure, void>> updateEvent({required EventModel event, File? imageCover});
  Future<Either<Failure, void>> cancelEvent({required EventModel event, String? reason});
  Future<Either<Failure, void>> joinEvent({required EventModel event});
}
