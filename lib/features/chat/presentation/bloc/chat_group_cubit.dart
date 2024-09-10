import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../domain/usecases/get_chat_group_room_messages_usecase .dart';

part 'chat_group_state.dart';

class ChatGroupCubit extends Cubit<ChatGroupState> {
  final GetChatGroupRoomMessagesUseCase getChatGroupRoomMessagesUseCase;
  ChatGroupCubit(
    this.getChatGroupRoomMessagesUseCase,
  ) : super(const ChatGroupState());

  void init(String roomId) async {
    print('... BLOC CHAT GROUP init');
    emit(state.copyWith(roomId: roomId));
    await getGroupRoomMessages();
  }

  Future getGroupRoomMessages(
      {bool? hideLoading = false, String? dateFrom}) async {
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
}
