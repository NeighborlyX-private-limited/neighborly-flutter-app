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
  int page = 1;
  bool hasReachedMax = false;
  void init(String roomId) async {
    page = 1;
    hasReachedMax = false;
    print('starting page:$page and starting hasReachedMax:$hasReachedMax');
    emit(state.copyWith(roomId: roomId));
    emit(
      state.copyWith(
        roomId: roomId,
        messages: [],
        hasReachedMax: hasReachedMax,
        page: page,
      ),
    );
    // CONNECT SOCKET
    // socketService.isSocketConnect = (value) {
    //   print('value: $value');
    //   if (value) {
    //     socketService.connect(groupId: roomId);
    //   }
    // };

    socketService.connect(groupId: roomId);
    // FEATCH GROUP MESSAGES
    await getGroupRoomMessages(roomId: roomId);

    // UPDATE MESSAGE LIST AFTER DELETE A MESSAGE
    socketService.messageDeleted = (messageId) {
      updateMessage(messageId);
    };

    // UPDATE MESSAGE LIST AFTER RECEIVING A NEW MESSAGE
    socketService.onNewMessageReceived = (message) {
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

  // UPDATE MESSAGE LIST AFTER DELETING A MESSAGE
  void updateMessage(String id) {
    List<ChatMessageModel> newMessages = state.messages
        .map((message) =>
            message.id == id ? message.copyWith(isDeleted: true) : message)
        .toList();

    emit(
      state.copyWith(
        status: Status.success,
        messages: List.from(newMessages),
      ),
    );
  }

  // UPDATE MESSAGE LIST AFTER PINING A MESSAGE
  void updateMessageForPinned(String id, bool isPinned) {
    List<ChatMessageModel> newMessages = state.messages
        .map((message) =>
            message.id == id ? message.copyWith(isPinned: isPinned) : message)
        .toList();

    emit(
      state.copyWith(
        status: Status.success,
        messages: List.from(newMessages),
      ),
    );
  }

  // ADD RECEIVED MESSAGE INTO THE CURRENT STATE
  addMessage(ChatMessageModel newMessage) {
    List<ChatMessageModel> oldMessages =
        List<ChatMessageModel>.from(state.messages);

    final updatedMessageList = [
      ...[newMessage],
      ...oldMessages,
    ];
    emit(state.copyWith(status: Status.success, messages: updatedMessageList));
  }

  // GET GROUP MESSAGES
  Future getGroupRoomMessages({
    required roomId,
  }) async {
    if (hasReachedMax) return;
    emit(state.copyWith(status: Status.loading));
    final result = await getChatGroupRoomMessagesUseCase(
      roomId: roomId,
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
        hasReachedMax = messageList.length < 20;

        emit(
          state.copyWith(
            status: Status.success,
            messages: messageList,
            hasReachedMax: hasReachedMax,
            page: 1,
          ),
        );
      },
    );
  }

  // FEATCH OLDER MESSAGE WITH PAGIGATION
  Future<void> fetchOlderMessages(String roomId) async {
    if (hasReachedMax || state.status == Status.loading) return;
    try {
      List<ChatMessageModel> olderMessages = state.messages;

      final result = await getChatGroupRoomMessagesUseCase(
        roomId: roomId,
        page: page + 1,
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
          if (messageList.length < 20) {
            hasReachedMax = true;
          } else {
            page++;
          }

          final updatedMessages = [
            ...olderMessages,
            ...messageList,
          ];

          emit(
            state.copyWith(
              messages: updatedMessages,
              hasReachedMax: hasReachedMax,
              page: page,
            ),
          );
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
    socketService.deleteMessage(groupId: groupId, messageId: messageId);
  }

  // LEAVE ROOM
  Future<void> disconnectChat(String roomId) async {
    socketService.dispose(roomId);
  }

  void setPagetoDefault() {
    emit(state.copyWith(page: 1));
  }
}
