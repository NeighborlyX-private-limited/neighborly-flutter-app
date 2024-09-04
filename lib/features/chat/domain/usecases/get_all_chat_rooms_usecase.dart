import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/chat_room_model.dart';
import '../repositories/chat_repositories.dart'; 

class GetAllChatRoomsUsecase {
  final ChatRepositories repository;

  GetAllChatRoomsUsecase(this.repository);

  Future<Either<Failure, List<ChatRoomModel>>> call( ) async {
    return await repository.getAllChatRooms();
  }
}
