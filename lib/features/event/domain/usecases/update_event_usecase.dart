import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../repositories/event_repositories.dart';

class UpdateEventUsecase {
  final EventRepositories repository;

  UpdateEventUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required EventModel event,
    File? imageCover,
  }) async {
    return await repository.updateEvent(
      event: event,
      imageCover: imageCover,
    );
  }
}
