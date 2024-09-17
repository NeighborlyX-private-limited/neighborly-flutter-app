part of 'chat_group_cubit_thread.dart';

class ChatGroupStateThread extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final File? imageToUpload;
  final String roomId;
  final List<ChatMessageModel> messages;

  const ChatGroupStateThread({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.roomId = '',
    this.imageToUpload,
    this.messages = const [],
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        imageToUpload,
        roomId,
        messages,
      ];

  ChatGroupStateThread copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    File? imageToUpload,
    String? roomId,
    List<ChatMessageModel>? messages,
  }) {
    return ChatGroupStateThread(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      roomId: roomId ?? this.roomId,
      messages: messages ?? this.messages,
    );
  }
}
