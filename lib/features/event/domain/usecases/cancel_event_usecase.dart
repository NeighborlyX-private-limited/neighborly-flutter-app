import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../repositories/event_repositories.dart';

class CancelEventUsecase {
  final EventRepositories repository;

  CancelEventUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required EventModel event,
    required String? reason,
  }) async {
    return await repository.cancelEvent(
      event: event,
      reason: reason, 
    );
  }
}
