part of 'chat_private_cubit.dart';

class ChatPrivateState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final File? imageToUpload;
  final String roomId;
  final List<ChatMessageModel> messages;

  const ChatPrivateState({
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

  ChatPrivateState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    File? imageToUpload,
    String? roomId,
    List<ChatMessageModel>? messages,
  }) {
    return ChatPrivateState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      roomId: roomId ?? this.roomId,
      messages: messages ?? this.messages,
    );
  }
}
