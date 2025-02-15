// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';
import '../../domain/usecases/get_all_chat_rooms_usecase_thread.dart';

part 'chat_main_state_thread.dart';

class ChatMainCubitThread extends Cubit<ChatMainStateThread> {
  final GetAllChatRoomsUsecaseThread getAllChatRoomsUsecase;
  late final _currentUser;
  Timer? _periodicPinger;

  ChatMainCubitThread(
    this.getAllChatRoomsUsecase,
  ) : super(ChatMainStateThread());

  void init() async {
    await getAllRooms();
  }

  Future getAllRooms() async {
    emit(state.copyWith(status: Status.loading));
    final result = await getAllChatRoomsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (roomList) {
        emit(state.copyWith(
            status: Status.success, rooms: roomList, roomsOriginal: roomList));
      },
    );
  }

  void cleanSearchFilter() {
    emit(state.copyWith(rooms: state.roomsOriginal, isSearching: false));
  }

  void filterRoomList(String termSearch) {
    emit(
      state.copyWith(
        isSearching: true,
        rooms: [
          ...state.roomsOriginal.where((element) =>
              element.name.toLowerCase().contains(termSearch.toLowerCase())),
        ],
      ),
    );
  }

//
  //
  // CHAT ###########################################################################
  // void _setupChatSocket() {
  //   var baseUrlSocket = kBaseSocketUrl;

  //   if (baseUrlSocket == '' || this._currentUser == null) return;

  //   if (socketChat != null) return;

  //   socketChat = io(
  //       baseUrlSocket,
  //       OptionBuilder()
  //           .setTransports(['websocket']) // for Flutter or Dart VM
  //           .disableAutoConnect() // disable auto-connection
  //           .setExtraHeaders({
  //             'Authorization': 'Bearer ' + this._currentUser!.token
  //           }) // optional
  //           .build());

  //   socketChat!.onConnect((_) {

  //   });

  //   socketChat!.on('friendActive', (data) {

  //   });

  //   socketChat!.on('getAllConversations', (data) {

  //     if (data == null) return;

  //     // var conversations = data.map<ConversationModel>((c) => ConversationModel.fromMap(c)).toList();

  //     // emit(state.copyWith(conversations: conversations));
  //   });

  //   socketChat!.on('newMessage', (data) {

  //     if (data == null) return;

  //     var message = ChatMessageModel.fromMap(data);

  //     emit(state.copyWith(messages: [...state.messages, message]));

  //     if (state.appIsOpen == false) {
  //       showLocalNotification('New Message', message.text);
  //     }
  //   });

  //   socketChat!.connect();
  //   socketChat!.emit('getConversations');

  // }

  // void startSocketPinger() {
  //   _periodicPinger = Timer.periodic(Duration(seconds: 10), (timer) {
  //     socketChat!.emit('ping');

  //   });
  // }

  // void chatSentMessage(String message, int friendId, int conversationId) {
  //   socketChat!.emit('sendMessage', {
  //     'message': message,
  //     'friendId': friendId,
  //     'conversationId': conversationId,
  //   });

  //   emit(state.copyWith(messages: [
  //     ...state.messages,
  //     ChatMessageModel(
  //         id: 'id',
  //         text: message,
  //         date: DateTime.now().toIso8601String(),
  //         isMine: false,
  //         readByuser: false,
  //         hasMore: false,
  //         pictureUrl: 'pictureUrl',
  //         isAdmin: false,
  //         isPinned: false,
  //         repliesCount: 0,
  //         cheers: 0,
  //         boos: 0,
  //         booOrCheer: 'message'),
  //   ]));
  // }

  Future<void> showLocalNotification(String title, String body) async {
    const appName = 'Neighborly';
    var androidChannelId = appName;
    var androidChannelName = '$appName Channel';
    var localeNotification = FlutterLocalNotificationsPlugin();

    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    int randomNumber = random.nextInt(100);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      androidChannelId, // Substitua pelo ID do seu canal de notificação
      androidChannelName, // Substitua pelo nome do seu canal de notificação
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await localeNotification.show(
      randomNumber, // ID da notificação
      title,
      body,
      platformChannelSpecifics,
    );
  }
  // int getConversationId(int friendId) {

  //   try {
  //     ConversationModel? conversartion = state.conversations.firstWhere(
  //       (element) => (element.userIds.contains(int.parse(_currentUser.id)) && element.userIds.contains(friendId)),
  //     );

  //     return conversartion?.id ?? 0;
  //   } catch (e) {
  //     return 0;
  //   }
  // }

  // END OF CHAT METHODS ############################################################
  // ################################################################################
}
