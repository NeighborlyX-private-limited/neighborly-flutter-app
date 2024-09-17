part of 'chat_main_cubit_thread.dart';

class ChatMainStateThread extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final List<ChatRoomModel> rooms;
  final List<ChatRoomModel> roomsOriginal;
  final List<ChatMessageModel> messages;
  final bool appIsOpen;
  final bool isSearching;

  const ChatMainStatetThread({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.rooms = const [],
    this.roomsOriginal = const [],
    this.messages = const [],
    this.isSearching = false,
    this.appIsOpen = true,
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        rooms,
        isSearching,
        messages,
        appIsOpen,
      ];

  ChatMainStateThread copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    List<ChatRoomModel>? rooms,
    List<ChatRoomModel>? roomsOriginal,
    bool? isSearching,
    List<ChatMessageModel>? messages,
    bool? appIsOpen,
  }) {
    return ChatMainState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      rooms: rooms ?? this.rooms,
      roomsOriginal: roomsOriginal ?? this.roomsOriginal,
      isSearching: isSearching ?? this.isSearching,
      messages: messages ?? this.messages,
      appIsOpen: appIsOpen ?? this.appIsOpen,
    );
  }
}
