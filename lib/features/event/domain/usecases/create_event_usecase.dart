import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../repositories/event_repositories.dart';

class CreateEventUsecase {
  final EventRepositories repository;

  CreateEventUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required EventModel event,
    File? imageCover,
  }) async {
    return await repository.createEvent(
      event: event,
      imageCover: imageCover,
    );
  }
}
