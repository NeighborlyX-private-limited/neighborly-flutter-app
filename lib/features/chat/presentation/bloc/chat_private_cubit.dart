import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/shared_preference.dart';

import '../../Socket/socket_service.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/dm_message_model.dart';
import '../../domain/usecases/get_chat_room_messages_usecase.dart';

part 'chat_private_state.dart';

class ChatPrivateCubit extends Cubit<ChatPrivateState> {
  final GetChatRoomMessagesUseCase getChatRoomMessagesUseCase;
  final SocketService socketService;
  ChatPrivateCubit(
    this.getChatRoomMessagesUseCase,
    this.socketService,
  ) : super(const ChatPrivateState());
  String? userName = ShardPrefHelper.getUsername();
  String? userImage = ShardPrefHelper.getUserProfilePicture();
  String? userId = ShardPrefHelper.getUserID();
  int page = 1;
  bool hasReachedMax = false;
  void init(String chatId) async {
    page = 1;
    hasReachedMax = false;
    print('starting page:$page and starting hasReachedMax:$hasReachedMax');
    emit(state.copyWith(chatId: chatId));
    emit(
      state.copyWith(
        chatId: chatId,
        messages: [],
        hasReachedMax: hasReachedMax,
        page: page,
      ),
      // await getRoomMessages(chatId: chatId);
    );
    socketService.connect(chatId: chatId);
    await getRoomMessages(chatId: chatId);
    socketService.activeUsersCount = (count) {
      activeUserCount(count);
    };
    socketService.DmMessageDeletedBySender = (msgId) {
      updateMessage(msgId);
      // upda(count);
    };
    socketService.onNewDmMessageReceived = (message) {
      print('this is new dm: $message');
      ChatMessageResponse chatmodel = ChatMessageResponse.fromJsonList([
        {
          'id': message['_id'],
          'chatId': message['chatId'],
          'senderId': message['senderId'],
          'message': message['message'],
          'mediaLink': message['mediaLink'],
          'isRead': message['isRead'],
          'isDeletedBySender': message['isDeletedBySender'],
          'isDeletedByReciever': message['isDeletedByReciever'],
          'replyTo': message['replyTo'] != null
              ? {
                  "messageId": message['replyTo']["messageId"],
                  "userId": message['replyTo']["userId"],
                  "name": message['replyTo']["name"],
                  "message": message['replyTo']["message"],
                  "mediaLink": message['replyTo']["mediaLink"] ?? "",
                }
              : null,
          'createdAt': message['createdAt'],
          // v: message['__v'],
          'isSender': message['isSender'],
        }
      ])[0];

      addMessage(chatmodel);
    };
    // void init(String roomId) async {
    //   emit(state.copyWith(roomId: roomId));
    //   await getRoomMessages();
    // }
  }

  // Future getRoomMessages({required  chatId}) async {
  //   if (!hideLoading!) {
  //     emit(state.copyWith(status: Status.loading));
  //   }
  //   final result = await getChatRoomMessagesUseCase(
  //       roomId: state.roomId, dateFrom: dateFrom);

  //   result.fold(
  //     (failure) {
  //       emit(state.copyWith(
  //           status: Status.failure,
  //           failure: failure,
  //           errorMessage: failure.message));
  //     },
  //     (messageList) {
  //       emit(state.copyWith(status: Status.success, messages: messageList));
  //     },
  //   );
  // }
  Future<void> disconnectChat(String chatId) async {
    socketService.dispose(chatId: chatId);
  }

  void sendDmMessage(
    Map<String, dynamic> payload,
    bool isMsg,
  ) {
    socketService.sendDmMessage(state.chatId, payload, isMsg);
  }

  activeUserCount(int count) {
    emit(state.copyWith(
      status: Status.success,
      activeUser: count,
    ));
  }

  // UPDATE MESSAGE LIST AFTER DELETING A MESSAGE
  void updateMessage(String id) {
    List<ChatMessageResponse> newMessages = state.messages
        .map(
            (msg) => msg.id == id ? msg.copyWith(isDeletedBySender: true) : msg)
        .toList();
    // List<ChatMessageResponse>.from(state.messages);

    // List<ChatMessageModel> newMessages = state.messages
    //     .map((message) =>
    //         message.id == id ? message.copyWith(isDeleted: true) : message)
    //     .toList();

    emit(
      state.copyWith(
        status: Status.success,
        messages: List.from(newMessages),
      ),
    );
  }

  addMessage(ChatMessageResponse newMessage) {
    List<ChatMessageResponse> oldMessages =
        List<ChatMessageResponse>.from(state.messages);
    print('old: ${state.messages}');

    final updatedMessageList = [
      ...[newMessage],
      ...oldMessages,
    ];
    emit(state.copyWith(status: Status.success, messages: updatedMessageList));
    print('new: ${state.messages}');
  }

  // DELETE  MESSAGE
  void deleteMessage({
    required String chatId,
    required String messageId,
  }) {
    socketService.deleteDMMessage(chatId: chatId, messageId: messageId);
  }

  // GET GROUP MESSAGES
  Future getRoomMessages({
    required chatId,
  }) async {
    if (hasReachedMax) return;
    emit(state.copyWith(status: Status.loading));
    final result = await getChatRoomMessagesUseCase(
      chatId: chatId,
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
        // hasReachedMax = messageList.messages.length < 20;

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

  // void testReceivingMessage() {
  //   final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  //   var newMessage = ChatMessageModel(
  //       id: '',
  //       text: 'are you there?',
  //       date: dateFormat.format(DateTime.now()),
  //       isMine: false,
  //       readByuser: false,
  //       hasMore: false,
  //       pictureUrl: '',
  //       isAdmin: false,
  //       isPinned: false,
  //       isDeleted: false,
  //       repliesCount: 0,
  //       cheers: 0,
  //       boos: 0,
  //       booOrCheer: '');
  //   emit(state.copyWith(
  //       status: Status.success, messages: [newMessage, ...state.messages]));
  // }

  //
  //
  // Future sendMessage({String? message, File? image}) async {
  //   final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   var newMessage = ChatMessageModel(
  //       id: '',
  //       text: message ?? '',
  //       date: dateFormat.format(DateTime.now()),
  //       isMine: true,
  //       readByuser: false,
  //       hasMore: false,
  //       pictureUrl: '',
  //       isAdmin: false,
  //       isPinned: false,
  //       isDeleted: false,
  //       repliesCount: 0,
  //       cheers: 0,
  //       boos: 0,
  //       booOrCheer: '');
  //   emit(state.copyWith(
  //       status: Status.success, messages: [newMessage, ...state.messages]));
  // }
}
