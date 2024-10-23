import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../domain/usecases/get_chat_group_room_messages_usecase .dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../Socket/socketService.dart'; // Import the SocketService
import '../../../../core/utils/shared_preference.dart';

part 'chat_group_state.dart';

class ChatGroupCubit extends Cubit<ChatGroupState> {
  final GetChatGroupRoomMessagesUseCase getChatGroupRoomMessagesUseCase;
  final SocketService socketService;
  ChatGroupCubit(
    this.getChatGroupRoomMessagesUseCase,
    this.socketService,
  ) : super(const ChatGroupState()) {
    // Initialize socket connection

    // Set the callback for receiving messages
    // socketService.onNewMessageReceived = (message) {
    //   addMessage(message); // Add message to state
    // };
  }
  String? userName = '';
  String? userImage = '';

  void init(String roomId) async {
    emit(state.copyWith(roomId: roomId));
    socketService.connect(groupId: roomId);
    await getGroupRoomMessages();
    socketService.onNewMessageReceived = (message) {
      ChatMessageModel chatmodel = ChatMessageModel.fromJsonList([
        {
          'id': DateTime.now().toString(),
          'date': DateTime.now().toString(),
          'isMine': false,
          'readByuser': false,
          'isAdmin': false,
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
      addMessage(chatmodel); // Add message to state
    };
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
        roomId: state.roomId, dateFrom: dateFrom);

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

  Future<void> fetchOlderMessages(
      {bool? hideLoading = false, String? dateFrom}) async {
    try {
      // Simulate fetching older messages from the server (implement API call)
      print(
          '... BLOC update getGroupRoomMessages hideLoading=$hideLoading dateFrom=$dateFrom');
      List<ChatMessageModel> olderMessages = state.messages;
      print('state.page ${state.page}');
      print(state.page + 1);
      final result = await getChatGroupRoomMessagesUseCase(
          roomId: state.roomId, dateFrom: dateFrom, page: state.page + 1);

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
          final updatedMessages = [...messageList, ...olderMessages];

          emit(state.copyWith(messages: updatedMessages, page: state.page + 1));
        },
      );
    } catch (e) {
      print('Error fetching older messages: $e');
    }
  }

  void sendMessage(var message, [bool isMsg = false]) {
    socketService.sendMessage(state.roomId, message, isMsg);
    print(' gg $userImage');
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

  void disconnectChat(String roomId) {
    print('disconnet');
    socketService.dispose(roomId);
  }

  // updateMessage(ChatMessageModel updatedMessage) {
  //   final updatedMessages = state.messages.map((message) {
  //     if(message.id == updatedMessage.id){
  //       print('sdffas $updatedMessage');
  //     }
  //       return message.id == updatedMessage.id ? updatedMessage : message;
  //     }).toList();
  //     print('update message $updatedMessages');
  //    emit(state.copyWith(
  //           status: Status.failure,
  //           errorMessage: 'dfsaf'));
  //   emit(state.copyWith(status: Status.success, messages: updatedMessages));
  // }

  addMessage(ChatMessageModel message) {
    List<ChatMessageModel> updatedMessages =
        List<ChatMessageModel>.from(state.messages);
    // updatedMessages.insert(0,message);

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

  void setPagetoDefault() {
    emit(state.copyWith(page: 1));
  }
}
