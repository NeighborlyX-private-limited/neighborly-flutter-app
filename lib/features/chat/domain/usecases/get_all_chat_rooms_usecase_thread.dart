import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_room_model.dart';
import '../repositories/chat_repositories_thread.dart';

class GetAllChatRoomsUsecaseThread {
  final ChatRepositoriesThread repository;

  GetAllChatRoomsUsecaseThread(this.repository);

  Future<Either<Failure, List<ChatRoomModel>>> call() async {
    return await repository.getAllChatRooms();
  }
}
