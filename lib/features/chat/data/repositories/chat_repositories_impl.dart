import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/chat_repositories.dart';
import '../data_sources/chat_remote_data_source/chat_remote_data_source.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';

class ChatRepositoriesImpl implements ChatRepositories {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ChatRoomModel>>> getAllChatRooms() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllChatRooms();
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getRoomMessages({required String roomId, String? dateFrom}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getRoomMessages(roomId: roomId, dateFrom: dateFrom);
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<ChatMessageModel>>> getGroupRoomMessages({required String roomId, String? dateFrom}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getGroupRoomMessages(roomId: roomId, dateFrom: dateFrom);
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
