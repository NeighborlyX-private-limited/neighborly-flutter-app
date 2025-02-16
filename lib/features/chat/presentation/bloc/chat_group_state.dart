part of 'chat_group_cubit.dart';

class ChatGroupState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final File? imageToUpload;
  final String roomId;
  final int page;
  final List<ChatMessageModel> messages;

  const ChatGroupState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.roomId = '',
    this.imageToUpload,
    this.page = 1,
    this.messages = const [],
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        imageToUpload,
        roomId,
        List.of(messages),
        page,
      ];

  ChatGroupState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    File? imageToUpload,
    String? roomId,
    int? page,
    List<ChatMessageModel>? messages,
  }) {
    return ChatGroupState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      roomId: roomId ?? this.roomId,
      messages: messages ?? this.messages,
      page: page ?? this.page,
    );
  }
}
