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
      print('New msg receive:$message');
      ChatMessageModel chatmodel = ChatMessageModel.fromJsonList([
        {
          'id': message['groupId'],
          'date': message['sendAt'],
          'isMine': false,
          'readByuser': false,
          'isAdmin': false,
          'isPinned': false,
          'repliesCount': 0,
          'cheers': message['cheers'],
          'boos': message['boos'],
          'booOrCheer': '',
          'pictureUrl': '',
          'text': message['message'],
          'author': {
            "userId": message['userId'],
            "userName": message['name'],
            "picture": "$userImage",
            "karma": 1
          }
        }
      ])[0];
      addMessage(chatmodel);
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
    bool? hideLoading = false,
    String? dateFrom,
  }) async {
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
      roomId: state.roomId,
    );

    result.fold(
      (failure) {
        print('...BLOC getGroupRoomMessages ERROR: ${failure.message}');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (messageList) {
        print('...BLOC getGroupRoomMessages list: $messageList');
        emit(state.copyWith(status: Status.success, messages: messageList));
      },
    );
  }

  Future<void> fetchOlderMessages({
    bool? hideLoading = false,
    String? dateFrom,
  }) async {
    try {
      // Simulate fetching older messages from the server (implement API call)
      print(
          '... BLOC update getGroupRoomMessages hideLoading=$hideLoading dateFrom=$dateFrom');
      List<ChatMessageModel> olderMessages = state.messages;
      print('olderMessages:${olderMessages.length}');
      print('state.page ${state.page}');
      print(state.page + 1);
      final result = await getChatGroupRoomMessagesUseCase(
        roomId: state.roomId,
        page: state.page + 1,
      );

      result.fold(
        (failure) {
          print('...BLOC getGroupRoomMessages ERROR: ${failure.message}');
          emit(
            state.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.message,
            ),
          );
        },
        (messageList) {
          print('...BLOC getGroupRoomMessages list: $messageList');
          final updatedMessages = [...messageList, ...olderMessages];

          emit(state.copyWith(messages: updatedMessages, page: state.page + 1));
        },
      );
    } catch (e) {
      print('Error fetching older messages: $e');
    }
  }

  /// send msg
  void sendMessage(Map<String, String> payload, bool isMsg) {
    socketService.sendMessage(state.roomId, payload, isMsg);
  }

  /// on disconnect
  void disconnectChat(String roomId) async {
    socketService.dispose(state.roomId);
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

  @override
  Future<void> close() {
    //socketService.dispose(); // Clean up the socket connection
    return super.close();
  }

  void setPagetoDefault() {
    emit(state.copyWith(page: 1));
  }
}
