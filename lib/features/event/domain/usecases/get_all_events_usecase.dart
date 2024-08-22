import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/event_model.dart';
import '../repositories/event_repositories.dart';

class GetEventsUsecase {
  final EventRepositories repository;

  GetEventsUsecase(this.repository);

  Future<Either<Failure, List<EventModel>>> call({
    required String scope,
    required String myOrOngoing,
    required String searchTerm,
    required String filterDateStart,
    required String filterDateEnd,
    required String filterCategory,
    required String filterLocation,
  }) async {
    return await repository.getEvents(
      scope: scope,
      myOrOngoing: myOrOngoing,
      searchTerm: searchTerm,
      filterDateStart: filterDateStart,
      filterDateEnd: filterDateEnd,
      filterCategory: filterCategory,
      filterLocation: filterLocation,
    );
  }
}
