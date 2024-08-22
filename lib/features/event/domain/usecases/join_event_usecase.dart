import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../repositories/event_repositories.dart';

class JoinEventUsecase {
  final EventRepositories repository;

  JoinEventUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required EventModel event, 
  }) async {
    return await repository.joinEvent(
      event: event, 
    );
  }
}
