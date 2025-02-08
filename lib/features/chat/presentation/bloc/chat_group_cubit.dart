import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../domain/usecases/get_chat_group_room_messages_usecase .dart';
import '../../Socket/socket_service.dart';
import '../../../../core/utils/shared_preference.dart';
part 'chat_group_state.dart';

class ChatGroupCubit extends Cubit<ChatGroupState> {
  final GetChatGroupRoomMessagesUseCase getChatGroupRoomMessagesUseCase;
  final SocketService socketService;
  ChatGroupCubit(
    this.getChatGroupRoomMessagesUseCase,
    this.socketService,
  ) : super(const ChatGroupState());
  String? userName = ShardPrefHelper.getUsername();
  String? userImage = ShardPrefHelper.getUserProfilePicture();
  String? userId = ShardPrefHelper.getUserID();

  void init(String roomId) async {
    emit(state.copyWith(roomId: roomId));

    /// socket connect
    socketService.connect(groupId: roomId);

    /// featch group messages
    await getGroupRoomMessages(roomId: roomId);

    /// listen for new messages
    socketService.onNewMessageReceived = (message) {
      print('NEW MESSAGE RECEIVED:$message');
      ChatMessageModel chatmodel = ChatMessageModel.fromJsonList([
        {
          'id': message['_id'],
          'date': message['sendAt'],
          'isMine': userId == message['userId'] ? true : false,
          'readByuser': false,
          'isAdmin': false,
          'isPinned': false,
          'repliesCount': 0,
          'cheers': message['cheers'],
          'boos': message['boos'],
          'booOrCheer': '',
          'pictureUrl': message['mediaLink'],
          // 'https://s3.amazonaws.com/www.neighborly.in/452e36e5-4afd-480b-90ce-c8119355110c-2025-02-06%2022%3A52%3A01.345569_compressed.jpeg',
          'text': message['message'],
          'author': {
            "userId": message['userId'],
            "userName": message['name'],
            "picture": "$userImage",
            "karma": 1
          }
        }
      ])[0];
      //if (message['parentMessageId'] == null) {
      addMessage(chatmodel);
      //}
    };
  }

  /// add msg
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

  /// get group msgs
  Future getGroupRoomMessages({
    required roomId,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getChatGroupRoomMessagesUseCase(
      roomId: state.roomId,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (messageList) {
        emit(
          state.copyWith(status: Status.success, messages: messageList),
        );
      },
    );
  }

  /// featch older msg with pagination
  Future<void> fetchOlderMessages() async {
    try {
      List<ChatMessageModel> olderMessages = state.messages;

      final result = await getChatGroupRoomMessagesUseCase(
        roomId: state.roomId,
        page: state.page + 1,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.message,
            ),
          );
        },
        (messageList) {
          int pageNumber = state.page;
          final updatedMessages = [...messageList, ...olderMessages];
          if (messageList.length < 10) {
            pageNumber = pageNumber;
          } else {
            pageNumber += 1;
          }
          emit(state.copyWith(messages: updatedMessages, page: pageNumber));
        },
      );
    } catch (e) {
      throw e.toString();
    }
  }

  /// send msg
  void sendMessage(
    Map<String, dynamic> payload,
    bool isMsg,
  ) {
    print(payload);
    socketService.sendMessage(state.roomId, payload, isMsg);
  }

  /// on disconnect
  void disconnectChat(String roomId) async {
    socketService.dispose(state.roomId);
  }

  // updateMessage(ChatMessageModel updatedMessage) {
  //   final updatedMessages = state.messages.map((message) {
  //     if(message.id == updatedMessage.id){

  //     }
  //       return message.id == updatedMessage.id ? updatedMessage : message;
  //     }).toList();

  //    emit(state.copyWith(
  //           status: Status.failure,
  //           errorMessage: 'dfsaf'));
  //   emit(state.copyWith(status: Status.success, messages: updatedMessages));
  // }

  @override
  Future<void> close() {
    //socketService.dispose(); // Clean up the socket connection
    return super.close();
  }

  void setPagetoDefault() {
    emit(state.copyWith(page: 1));
  }
}
