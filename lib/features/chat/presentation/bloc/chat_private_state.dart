part of 'chat_private_cubit.dart';

class ChatPrivateState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage;
  final File? imageToUpload;
  final String chatId;
  final List<ChatMessageResponse> messages;
  final int page;
  final int activeUser;
  final bool hasReachedMax;

  const ChatPrivateState(
      {this.activeUser = 0,
      this.status = Status.initial,
      this.failure,
      this.errorMessage = '',
      this.chatId = '',
      this.imageToUpload,
      this.page = 1,
      this.hasReachedMax = false,
      this.messages = const []});

  @override
  List<Object?> get props => [
        activeUser,
        status,
        failure,
        errorMessage,
        imageToUpload,
        chatId,
        messages,
        page,
        hasReachedMax,
      ];

  ChatPrivateState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage,
    File? imageToUpload,
    String? chatId,
    List<ChatMessageResponse>? messages,
    int? page,
    int? activeUser,
    bool? hasReachedMax,
  }) {
    return ChatPrivateState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      imageToUpload: imageToUpload ?? this.imageToUpload,
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      page: page ?? this.page,
      activeUser: activeUser ?? this.activeUser,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
