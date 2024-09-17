import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../domain/usecases/get_chat_room_messages_usecase.dart';

part 'chat_private_state.dart';

class ChatPrivateCubit extends Cubit<ChatPrivateState> {
  final GetChatRoomMessagesUseCase getChatRoomMessagesUseCase;
  ChatPrivateCubit(
    this.getChatRoomMessagesUseCase,
  ) : super(const ChatPrivateState());

  void init(String roomId) async {
    print('... BLOC CHAT INDIVIDUAL init');
    emit(state.copyWith(roomId: roomId));
    await getRoomMessages();
  }

  Future getRoomMessages({bool? hideLoading = false, String? dateFrom}) async {
    print(
        '... BLOC getRoomMessages hideLoading=$hideLoading dateFrom=$dateFrom');
    if (!hideLoading!) {
      emit(state.copyWith(status: Status.loading));
    }
    final result = await getChatRoomMessagesUseCase(
        roomId: state.roomId, dateFrom: dateFrom);

    result.fold(
      (failure) {
        print('...BLOC getRoomMessages ERROR: ${failure.message}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (messageList) {
        print('...BLOC getRoomMessages list: ${messageList}');
        emit(state.copyWith(status: Status.success, messages: messageList));
      },
    );
  }

  void testReceivingMessage() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    var newMessage = ChatMessageModel(
      id: '',
      text: 'are you there?',
      date: dateFormat.format(DateTime.now()),
      isMine: false,
      readByuser: false,
      hasMore: false,
      pictureUrl: '',
      isAdmin: false,
      isPinned: false,
      repliesCount: 0,
      cheers: 0,
      boos: 0,
      booOrCheer: ''
    );
    emit(state.copyWith(
        status: Status.success, messages: [newMessage, ...state.messages]));
  }

  //
  //
  Future sendMessage({String? message, File? image}) async {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var newMessage = ChatMessageModel(
      id: '',
      text: message ?? '',
      date: dateFormat.format(DateTime.now()),
      isMine: true,
      readByuser: false,
      hasMore: false,
      pictureUrl: '',
      isAdmin: false,
      isPinned: false,
      repliesCount: 0,
      cheers: 0,
      boos: 0,
      booOrCheer: ''
    );
    emit(state.copyWith(
        status: Status.success, messages: [newMessage, ...state.messages]));
  }
}
