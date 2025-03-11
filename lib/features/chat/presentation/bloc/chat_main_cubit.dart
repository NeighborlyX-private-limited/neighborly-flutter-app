import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';
import '../../domain/usecases/get_all_chat_rooms_usecase.dart';
part 'chat_main_state.dart';

class ChatMainCubit extends Cubit<ChatMainState> {
  final GetAllChatRoomsUsecase getAllChatRoomsUsecase;
  late Socket? socketChat;
  late final _currentUser;
  Timer? _periodicPinger;

  ChatMainCubit(
    this.getAllChatRoomsUsecase,
  ) : super(const ChatMainState());

  void init() async {
    await getAllRooms();
  }

  // SOCKET INITIALIZATION
  void initSocket() {
    _setupChatSocket();
  }

// GET ALL CHAT ROOMS
  Future getAllRooms() async {
    emit(state.copyWith(status: Status.loading));
    final result = await getAllChatRoomsUsecase();

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
      (roomList) {
        emit(
          state.copyWith(
            status: Status.success,
            rooms: roomList,
            roomsOriginal: roomList,
          ),
        );
      },
    );
  }

// CLEAR SEARCH FILTER
  void cleanSearchFilter() {
    emit(
      state.copyWith(
        rooms: state.roomsOriginal,
        isSearching: false,
      ),
    );
  }

// ROOM SEARCH FILTER IN LOCAL ROOM LIST
  void filterRoomList(String termSearch) {
    emit(
      state.copyWith(
        isSearching: true,
        rooms: [
          ...state.roomsOriginal.where(
            (element) => element.name.toLowerCase().contains(
                  termSearch.toLowerCase(),
                ),
          ),
        ],
      ),
    );
  }

  void _setupChatSocket() {
    var baseUrlSocket = kBaseSocketUrl;

    if (baseUrlSocket == '' || _currentUser == null) return;

    if (socketChat != null) return;

    socketChat = io(
      baseUrlSocket,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': _currentUser!.token})
          .build(),
    );

    socketChat!.onConnect((_) {});

    socketChat!.on('friendActive', (data) {});

    socketChat!.on('getAllConversations', (data) {
      if (data == null) return;
    });

    socketChat!.on('newMessage', (data) {
      if (data == null) return;

      var message = ChatMessageModel.fromMap(data);

      emit(state.copyWith(messages: [...state.messages, message]));

      if (state.appIsOpen == false) {
        showLocalNotification('New Message', message.text);
      }
    });

    socketChat!.connect();
    socketChat!.emit('getConversations');
  }

  void startSocketPinger() {
    _periodicPinger = Timer.periodic(Duration(seconds: 10), (timer) {
      socketChat!.emit('ping');
    });
  }

  void chatSentMessage(String message, int friendId, int conversationId) {
    socketChat!.emit('sendMessage', {
      'message': message,
      'friendId': friendId,
      'conversationId': conversationId,
    });

    emit(
      state.copyWith(
        messages: [
          ...state.messages,
          ChatMessageModel(
            id: 'id',
            text: message,
            date: DateTime.now().toIso8601String(),
            isMine: false,
            readByuser: false,
            hasMore: false,
            pictureUrl: 'pictureUrl',
            isAdmin: false,
            isPinned: false,
            isDeleted: false,
            repliesCount: 0,
            cheers: 0,
            boos: 0,
            booOrCheer: 'message',
          ),
        ],
      ),
    );
  }

  Future<void> showLocalNotification(String title, String body) async {
    const appName = 'Neighborly';
    var androidChannelId = appName;
    var androidChannelName = '$appName Channel';
    var localeNotification = FlutterLocalNotificationsPlugin();

    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    int randomNumber = random.nextInt(100);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await localeNotification.show(
      randomNumber,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
