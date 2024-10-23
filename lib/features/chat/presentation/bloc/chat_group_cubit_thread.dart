import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../domain/usecases/get_chat_group_room_messages_usecase_thread.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../Socket/socketService.dart'; // Import the SocketService
import '../../../../core/utils/shared_preference.dart';

part 'chat_group_state_thread.dart';

class ChatGroupCubitThread extends Cubit<ChatGroupStateThread> {
  final GetChatGroupRoomMessagesUseCaseThread getChatGroupRoomMessagesUseCase;
  final SocketService socketService;
  ChatGroupCubitThread(
    this.getChatGroupRoomMessagesUseCase,
    this.socketService,
  ) : super(const ChatGroupStateThread()) {
    // // Initialize socket connection
    //  socketService.connect();
  }
  String? userName = '';
  String? userImage = '';

  void init(String roomId) async {
    print('... BLOC CHAT GROUP init');
    emit(state.copyWith(roomId: roomId));
    await getGroupRoomMessages();
  }

  Future getGroupRoomMessages(
      {bool? hideLoading = false, String? dateFrom}) async {
    String? userN = ShardPrefHelper.getUsername();
    String? userI = ShardPrefHelper.getUserProfilePicture();
    userName = userN;
    userImage = userI;

    print(
        '... BLOC getGroupRoomMessages hideLoading=$hideLoading dateFrom=$dateFrom');
    if (!hideLoading!) {
      emit(state.copyWith(status: Status.loading));
    }
    final result = await getChatGroupRoomMessagesUseCase(
        roomId: state.roomId, dateFrom: dateFrom, isreply: true);

    result.fold(
      (failure) {
        print('...BLOC getGroupRoomMessages ERROR: ${failure.message}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (messageList) {
        print('...BLOC getGroupRoomMessages list: ${messageList}');
        emit(state.copyWith(status: Status.success, messages: messageList));
      },
    );
  }

  void sendMessage(var message, [bool isMsg = false]) {
    socketService.sendMessage(state.roomId, message, isMsg);
    if (isMsg) {
      ChatMessageModel chatmodel = ChatMessageModel.fromJsonList([
        {
          'id': DateTime.now().toString(),
          'date': DateTime.now().toString(),
          'isMine': true,
          'readByuser': true,
          'isAdmin': true,
          'isPinned': false,
          'repliesCount': 0,
          'cheers': 0,
          'boos': 0,
          'booOrCheer': '',
          'pictureUrl': '',
          'text': message['msg'],
          'author': {
            "userId": "1111",
            "userName": "$userName",
            "picture": "$userImage",
            "karma": 1
          }
        }
      ])[0];
      addMessage(chatmodel);
    }
  }

  addMessage(ChatMessageModel message) {
    List<ChatMessageModel> updatedMessages =
        List<ChatMessageModel>.from(state.messages);

    // Emit the updated state with the new list of messages
    final updatedMessagesList = [
      ...updatedMessages,
      ...[message]
    ];
    emit(state.copyWith(status: Status.success, messages: updatedMessagesList));
  }

  @override
  Future<void> close() {
    //socketService.dispose(); // Clean up the socket connection
    return super.close();
  }
}
