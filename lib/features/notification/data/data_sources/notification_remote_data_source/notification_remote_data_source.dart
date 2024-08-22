import '../../model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getAllNotification({String? page});

  Future<String> updateFCMtoken();
}
