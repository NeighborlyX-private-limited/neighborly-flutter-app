// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/shared_preference.dart';
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
    print('... BLOC CHAT MAIN init');
    await getAllRooms();

    var cookieData = ShardPrefHelper.getCookie();

    print('...cookieData=$cookieData');
  }

  Future getAllRooms() async {
    emit(state.copyWith(status: Status.loading));
    final result = await getAllChatRoomsUsecase();

    result.fold(
      (failure) {
        print('ERROR: ${failure.message}');
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
  //   print(
  //       '... CUBIT init _setupChatSocket baseUrlSocket=$baseUrlSocket _currentUser=${this._currentUser}');
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
  //     print('... SOCK_CHAT: connect');
  //   });

  //   socketChat!.on('friendActive', (data) {
  //     print('... SOCK_CHAT: on=friendActive:: ');
  //   });

  //   socketChat!.on('getAllConversations', (data) {
  //     print('... SOCK_CHAT: on=getAllConversations:: ');
  //     print(data);
  //     // print(data['isActive'].runtimeType);

  //     if (data == null) return;

  //     // var conversations = data.map<ConversationModel>((c) => ConversationModel.fromMap(c)).toList();

  //     // print('... SOCK_CHAT conversations=${conversations}');

  //     // emit(state.copyWith(conversations: conversations));
  //   });

  //   socketChat!.on('newMessage', (data) {
  //     print('... SOCK_CHAT: on=newMessage:: ');
  //     print(data);
  //     // print(data['isActive'].runtimeType);

  //     if (data == null) return;

  //     var message = ChatMessageModel.fromMap(data);

  //     print(
  //         '... SOCK_CHAT message=${message} state.appIsOpen=${state.appIsOpen}');

  //     emit(state.copyWith(messages: [...state.messages, message]));

  //     if (state.appIsOpen == false) {
  //       showLocalNotification('New Message', message.text);
  //     }
  //   });

  //   socketChat!.onDisconnect((_) => print('... SOCK_CHAT: disconnect'));
  //   socketChat!
  //       .onConnectError((data) => print('... SOCK_CHAT: error: ${data}'));

  //   socketChat!.connect();
  //   socketChat!.emit('getConversations');
  //   print('... SOCK_CHAT: setup done');
  // }

  // void startSocketPinger() {
  //   _periodicPinger = Timer.periodic(Duration(seconds: 10), (timer) {
  //     socketChat!.emit('ping');
  //     print('... SOCK_CHAT: ping');
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

    print(
        '... APP CUBIT showLocalNotification androidChannelId=$androidChannelId androidChannelName=$androidChannelName randomNumber=$randomNumber');

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
  //   print('... getConversationId friendId=${friendId}');
  //   print('... getConversationId _currentUser.id=${_currentUser.id}');
  //   print('... getConversationId state.conversations=${state.conversations}\n');

  //   // print('... getConversationId check1=${state.conversations[0].userIds.contains(int.parse(_currentUser.id))}');
  //   // print('... getConversationId check2=${state.conversations[0].userIds.contains(friendId)}');
  //   // print('... getConversationId check1.=${state.conversations[0].userIds[0]}');
  //   // print('... getConversationId check1.=${state.conversations[0].userIds[0].runtimeType}');

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
