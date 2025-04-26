import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/features/chat/domain/usecases/get_nearby_user_usecase.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/bloc/bloc/nearby_user_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/chat_repositories.dart';
import '../data_sources/chat_remote_data_source/chat_remote_data_source.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';
import '../model/interest_model.dart';
import '../model/nearby_user_model.dart';
import '../model/pinned_message_model.dart';

class ChatRepositoriesImpl implements ChatRepositories {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
// GET ALL CHAT ROOMS
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
  Future<Either<Failure, List<ChatMessageModel>>> getRoomMessages(
      {required String chatId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getRoomMessages(
          chatId: chatId,
        );
        // print('response:$result');
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
  Future<Either<Failure, List<PinnedMessageModel>>> featchPinnedMessages({
    required String groupId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.featchPinnedMessages(
          groupId: groupId,
        );
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

  // Future<String> pinnedMessage({
  //   required String messagesId,
  // });
  @override
  Future<Either<Failure, String>> pinnedMessage({
    required String messageId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.pinnedMessage(
          messageId: messageId,
        );
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

  // GET GROUP CHAT
  @override
  Future<Either<Failure, List<ChatMessageModel>>> getGroupRoomMessages({
    required String roomId,
    bool isreply = false,
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getGroupRoomMessages(
          roomId: roomId,
          isreply: isreply,
          page: page,
        );
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

  // GET GROUP CHAT
  @override
  Future<Either<Failure, InterestModel>> getAllInterests() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllInterests();
        print('thisis re: $result');
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
  Future<Either<Failure, String>> createDm({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createDm(userId: userId);
        // print('thisis re: $result');
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

  // GET GROUP CHAT
  @override
  Future<Either<Failure, List<NearbyUserModel>>> getNearByUser() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getNearByUser();
        print('thisis re: $result');
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

  // GET GROUP CHAT
  @override
  Future<Either<Failure, void>> saveUserInterest({
    required List<String> userInterest,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await remoteDataSource.saveUserInterest(userInterest: userInterest);
        // print('thisis re: $result');
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
