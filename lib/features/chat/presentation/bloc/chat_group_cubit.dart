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

    // CONNECT SOCKET
    socketService.connect(groupId: roomId);

    // FEATCH GROUP MESSAGES
    await getGroupRoomMessages(roomId: roomId);

    socketService.messageDeleted = (messageId) {
      print('DELETED MESSAGE ID: $messageId');
      updateMessage(messageId);
    };

    // LISTEN NEW MESSAGE
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
          'isDeleted': message['isDeleted'],
          'repliesCount': 0,
          'cheers': message['cheers'],
          'boos': message['boos'],
          'booOrCheer': '',
          'mediaLink': message['mediaLink'] ?? '',
          'text': message['message'] ?? "",
          'author': {
            "userId": message['userId'],
            "userName": message['name'],
            "picture": "$userImage",
            "karma": 1
          },
          'repliedTo': message['repliedTo'] != null
              ? {
                  "messageId": message['repliedTo']["messageId"],
                  "userId": message['repliedTo']["userId"],
                  "name": message['repliedTo']["name"],
                  "message": message['repliedTo']["message"],
                  "mediaLink": message['repliedTo']["mediaLink"] ?? "",
                }
              : null,
        }
      ])[0];

      addMessage(chatmodel);
    };
  }

  void updateMessage(String id) {
    List<ChatMessageModel> newMessages = state.messages
        .map((message) =>
            message.id == id ? message.copyWith(isDeleted: true) : message)
        .toList(); // ✅ Creates a new list reference

    print('🚀 State Before Emit: $newMessages');

    emit(state.copyWith(
      status: Status.success,
      messages: List.from(newMessages), // ✅ Ensures new list reference
    ));

    print('🔥 State After Emit: ${state.messages}');
  }

  void updateMessageForPinned(String id, bool isPinned) {
    List<ChatMessageModel> newMessages = state.messages
        .map((message) =>
            message.id == id ? message.copyWith(isPinned: isPinned) : message)
        .toList(); // ✅ Creates a new list reference

    print('🚀 State Before Emit: $newMessages');

    emit(state.copyWith(
      status: Status.success,
      messages: List.from(newMessages), // ✅ Ensures new list reference
    ));

    print('🔥 State After Emit: ${state.messages}');
  }

  // ADD RECEIVED MESSAGE INTO THE CURRENT STATE
  addMessage(ChatMessageModel newMessage) {
    List<ChatMessageModel> oldMessages =
        List<ChatMessageModel>.from(state.messages);

    final updatedMessageList = [
      ...oldMessages,
      ...[newMessage]
    ];
    emit(state.copyWith(status: Status.success, messages: updatedMessageList));
  }

  // GET GROUP MESSAGES
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

  // FEATCH OLDER MESSAGE WITH PAGIGATION
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

  // SEND MESSAGE
  void sendMessage(
    Map<String, dynamic> payload,
    bool isMsg,
  ) {
    socketService.sendMessage(state.roomId, payload, isMsg);
  }

  // DELETE  MESSAGE
  void deleteMessage({
    required String groupId,
    required String messageId,
  }) {
    print('DELETE MESSAGE CALLED IN CUBIT');
    socketService.deleteMessage(groupId: groupId, messageId: messageId);
  }

  // LEAVE ROOM
  void disconnectChat(String roomId) async {
    socketService.dispose(roomId);
  }

  void setPagetoDefault() {
    emit(state.copyWith(page: 1));
  }
}
