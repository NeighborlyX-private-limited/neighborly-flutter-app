import 'dart:io';

import '../../model/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents(
      {required String scope,
      required String myOrOngoing,
      required String searchTerm,
      required String filterDateStart,
      required String filterDateEnd,
      required String filterCategory,
      required String filterLocation});

  Future<void> createEvent({required EventModel event, File? imageCover});
  Future<void> updateEvent({required EventModel event, File? imageCover});
  Future<void> cancelEvent({required EventModel event, String? reason});
  Future<void> joinEvent({required EventModel event});
}
