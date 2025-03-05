import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_sizedbox.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../../communities/presentation/bloc/bloc/join_group_bloc.dart';
import '../../../communities/presentation/bloc/communities_main_cubit.dart';
import '../../../communities/presentation/bloc/community_detail_cubit.dart';
import '../../../posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import '../../../upload/presentation/bloc/upload_file_bloc/upload_file_bloc.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';
import '../bloc/chat_group_cubit.dart';
import '../bloc/pin_message_bloc.dart';
import '../widgets/chat_messages_group_sheemer.dart';
import '../../../../core/constants/imagepickercompress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/media_message_widget.dart';

class ChatGroupScreen extends StatefulWidget {
  final ChatRoomModel chatRoom;
  final String roomId;

  const ChatGroupScreen({
    super.key,
    required this.roomId,
    required this.chatRoom,
  });

  @override
  State<ChatGroupScreen> createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatGroupCubit chatGroupCubit;
  late CommunityMainCubit communityMainCubit;
  late CommunityDetailsCubit communityDetailCubit;

  List<UserSimpleModel> admins = [];
  List<UserSimpleModel> members = [];

  final messageEC = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  String cuurentUserId = '';

  bool isCommentFilled = false;
  bool isReply = false;
  bool showPinned = true;

  File? imageToUpload;
  File? _videoFile;
  File? _pickedFile;

  String? _selectedMessageId;
  String? _selectedMessageUserId;
  String? _messageToReply;
  String? _mediaToReply;
  String? _messageToReplyUserName;

  // INIT STATE
  @override
  void initState() {
    super.initState();

    communityDetailCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    chatGroupCubit = BlocProvider.of<ChatGroupCubit>(context);

    communityDetailCubit.getCommunityDetail(widget.roomId);
    chatGroupCubit.init(widget.roomId);
    getCurrentUserId();
    _scrollController.addListener(_onScroll);
  }

  // CHECK IS USER TRY TO FEATCH OLDER MESSAGES
  void _onScroll() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await chatGroupCubit.fetchOlderMessages(widget.roomId);
    }
  }

// GET CURRENT USER ID
  void getCurrentUserId() {
    cuurentUserId = ShardPrefHelper.getUserID() ?? '';
  }

// CHECK IF CURRENT USER IS AN ADMIN
  bool isCurrentUserAdmin() {
    return admins.any((admin) => admin.id == cuurentUserId);
  }

// CHECK IF SENDER USER IS AN ADMIN
  bool isSenderAnAdmin(String userId) {
    return admins.any((admin) => admin.id == userId);
  }

// GET THE PROFILE PIC OF THE SENDER
  String getSenderProfilePic(String userId) {
    final member = members.firstWhere(
      (member) => member.id == userId,
      orElse: () => UserSimpleModel(
        id: '',
        name: 'Unknown',
        avatarUrl: 'default',
      ),
    );

    if (member.avatarUrl == 'default') {
      return '';
    }
    return member.avatarUrl;
  }

  // DISPOSE
  @override
  void dispose() {
    _scrollController.dispose();
    chatGroupCubit.setPagetoDefault();
    messageEC.dispose();
    super.dispose();
  }

  // PIC IMAGE
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery).then((file) {
      return compressImage(imageFileX: file);
    });

    if (imageFile != null) {
      setState(() {
        imageToUpload = File(imageFile.path);
      });
    }
  }

  // PIC FILE
  Future<void> pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickMedia();

    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile.path);
      });
    }
  }

  // PIC VIDEO
  Future<void> _pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedVideoFile = await picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedVideoFile != null) {
        setState(() {
          _videoFile = File(pickedVideoFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context: context, message: 'oops something went wrong');
      }
    }
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.read<ChatGroupCubit>().disconnectChat(widget.roomId);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: BlocConsumer<CommunityDetailsCubit, CommunityDetailsState>(
        listener: (BuildContext context, CommunityDetailsState state) {
          // FAILURE STATE
          if (state.status == Status.failure) {
            showSnackBar(
              context: context,
              message: 'oops something went wrong',
            );
          }
          // SUCCESS STATE
          if (state.status == Status.success) {
            admins = state.community?.admins ?? [];
            members = state.community?.users ?? [];
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            // APPBAR AREA
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.whiteColor,
              title: GestureDetector(
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<ChatGroupCubit>()
                        .disconnectChat(widget.roomId);
                    Navigator.pop(context);
                  },
                  child: appBarTitleArea(),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    bool isAdmin = isCurrentUserAdmin();
                    context.push(
                      '/group-chat-pinned-message/${widget.roomId}/${isAdmin ? "true" : "false"}',
                    );
                  },
                  icon: Icon(
                    Icons.push_pin,
                    size: 24,
                    color: AppColors.greyColor,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            // BODY AREA
            body: BlocConsumer<ChatGroupCubit, ChatGroupState>(
              listener: (context, state) {
                // FAILURE STATE
                if (state.status == Status.failure) {
                  showSnackBar(
                    context: context,
                    message:
                        state.failure?.message ?? 'oops something went wrong',
                  );
                }
              },
              //  BLOC BUILDER
              builder: (context, state) {
                // LOADING STATE
                if (state.status == Status.loading) {
                  return Container(
                    color: Colors.white,
                    child: ChatMessagesGroupSheemer(),
                  );
                }
                // SUCCESS STATE
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 2,
                    ),

                    state.status == Status.success && state.messages.isEmpty
                        // SHOW EMPTY MESSAGE SCREEN
                        ? Expanded(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                alignment: Alignment.center,
                                child: NoMessage(),
                              ),
                            ),
                          )

                        // PIN MESSAGE BLOC LISTENER
                        : BlocListener<PinMessageBloc, PinMessagesState>(
                            listener: (context, state) {
                              // SUCCESS STATE
                              if (state is PinMessagesStateSuccessState) {
                                showSnackBar(
                                  context: context,
                                  message: state.message,
                                );
                              }

                              // FAILURE STATE
                              if (state is PinMessagesStateFailureState) {
                                showSnackBar(
                                  context: context,
                                  message: 'oops something went wrong',
                                );
                              }
                            },
                            child: Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                itemCount: state.messages.length +
                                    (state.hasReachedMax ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index >= state.messages.length) {
                                    return CustomCircularIndicator();
                                  }
                                  // CHECK IF THE CURRENT AND PRIVIOUS MESSAGE SENDER IS SAME OR NOT
                                  var msg = state.messages[index];

                                  final bool isNewMsg = index ==
                                          state.messages.length - 1 ||
                                      msg.author?.id !=
                                          state.messages[index + 1].author?.id;

                                  // CHECK SENDER USER IS ADMIN OR NOT
                                  final bool isSenderAdmin =
                                      isSenderAnAdmin(msg.author!.id);

                                  // CHECK CURRENT USER IS ADMIN OR NOT
                                  final bool isAdmin = isCurrentUserAdmin();

                                  // GET PROFILE PIC OF THE  SENDER USER
                                  final String senderProfilePic =
                                      getSenderProfilePic(msg.author!.id);

                                  // NEED TO THINK ABOUT THIS LINE

                                  final bool isNewDate = index ==
                                          state.messages.length - 1 ||
                                      DateUtilsHelper.simplifyISOtimeString(
                                              state.messages[index].date
                                                  .toString()) !=
                                          DateUtilsHelper.simplifyISOtimeString(
                                              state.messages[index + 1].date
                                                  .toString());

                                  return Column(
                                    children: [
                                      if (isNewDate)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withOpacity(.1),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            '${formatTimeDifference(
                                              state.messages[index].date
                                                  .toString(),
                                            )} ',
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ChatMessageGroupWidget(
                                        message: msg,
                                        isCurrentUser:
                                            (msg.author?.id == cuurentUserId),
                                        isAdmin: isAdmin,
                                        isNewMsg: isNewMsg,
                                        isSenderAdmin: isSenderAdmin,
                                        senderProfilePic: senderProfilePic,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                    // IF REPLY IS TRUE SHOW REPLYING TO CARD ABOVE TEXT FIELD
                    if (isReply)
                      Container(
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 68,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border(
                              left: BorderSide(
                                color: AppColors.primaryColor,
                                width: 4,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '~$_messageToReplyUserName',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _clearReply,
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_messageToReply != '' &&
                                      _messageToReply != null)
                                    Expanded(
                                      child: Text(
                                        '$_messageToReply',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  if (_mediaToReply != '' &&
                                      _mediaToReply != null)
                                    SizedBox(
                                      height: 80,
                                      child: MediaMessageWidget(
                                        fileUrl: _mediaToReply!,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    // SHOW PICKED MEDIA PREVIEW
                    if (imageToUpload != null)
                      Container(
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 70,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border(
                              left: BorderSide(
                                color: AppColors.primaryColor,
                                width: 4,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  imageToUpload!,
                                  height: 150,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              GestureDetector(
                                onTap: _clearReply,
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    messageInputSection(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  // NO MESSAGE WIDGET
  Widget NoMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/empty_chat.svg',
          ),
          CustomSizedBox(
            height: 12,
          ),
          Text(
            'Welcome to chat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomSizedBox(
            height: 4,
          ),
          Text(
            'Engage by joining communities or sending direct messages.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          )
        ],
      ),
    );
  }

  // APPBAR TITLE AREA
  Widget appBarTitleArea() {
    return Row(
      children: [
        GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            context.read<ChatGroupCubit>().disconnectChat(widget.roomId);
            Navigator.pop(context);
          },
        ),
        const SizedBox(
          width: 10,
        ),
        if (widget.chatRoom.avatarUrl != '')
          GestureDetector(
            onTap: () {
              context.read<ChatGroupCubit>().disconnectChat(widget.roomId);
              Navigator.pop(context);
            },
            child: UserAvatarStyledWidget(
              avatarUrl: widget.chatRoom.avatarUrl,
              avatarSize: 19,
              avatarBorderSize: 0,
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.chatRoom.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  // MESSAGE INPUT AREA
  Widget messageInputSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
          top: 4,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                controller: messageEC,
                focusNode: messageFocusNode,
                onChanged: (value) {
                  if (value.trim() != "") {
                    setState(() {
                      isCommentFilled = messageEC.text.isNotEmpty;
                    });
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: pickImage,
                    // onTap: showMediaOption,
                    child: Icon(
                      Icons.photo_camera_back_outlined,
                      color: Colors.grey[600],
                    ),
                  ),
                  hintText: isReply ? 'Reply' : 'Message',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // SEND BUTTONS

            BlocConsumer<UploadFileBloc, UploadFileState>(
              listener: (context, state) {
                // FAILURE STATE
                if (state is UploadFileFailureState) {
                  isReply = false;

                  messageEC.clear();

                  _messageToReply = null;
                  _mediaToReply = null;
                  _selectedMessageId = null;
                  _messageToReplyUserName = null;
                  _selectedMessageUserId = null;

                  imageToUpload = null;
                  _videoFile = null;
                  _pickedFile = null;

                  showSnackBar(context: context, message: state.error);
                }
                // SUCCESS STATE
                if (state is UploadFileSuccessState) {
                  String fileUrl = state.url;

                  if (messageEC.text.trim() != "" || imageToUpload != null) {
                    final payload = {
                      'groupId': widget.roomId,
                      'message': messageEC.text,
                      'repliedTo': isReply
                          ? {
                              'messageId': _selectedMessageId,
                              'userId': _selectedMessageUserId,
                              'name': _messageToReplyUserName,
                              'message': _messageToReply,
                              'media': _mediaToReply,
                            }
                          : null,
                      'file': fileUrl,
                    };

                    context.read<ChatGroupCubit>().sendMessage(payload, true);

                    isReply = false;

                    messageEC.clear();

                    _messageToReply = null;
                    _mediaToReply = null;
                    _selectedMessageId = null;
                    _messageToReplyUserName = null;
                    _selectedMessageUserId = null;

                    imageToUpload = null;
                    _videoFile = null;
                    _pickedFile = null;
                  }
                }
              },
              builder: (context, state) {
                // LOADING STATE
                if (state is UploadFileLoadingState) {
                  return CustomCircularIndicator();
                }
                return InkWell(
                  onTap: () async {
                    if (!widget.chatRoom.isJoined) {
                      _showJoinGroupBottomSheet(context);
                    } else {
                      if (imageToUpload != null) {
                        context.read<UploadFileBloc>().add(
                              UploadFilePressedEvent(file: imageToUpload!),
                            );
                      } else if (messageEC.text.trim() != "") {
                        final payload = {
                          'groupId': widget.roomId,
                          'message': messageEC.text,
                          'repliedTo': isReply
                              ? {
                                  'messageId': _selectedMessageId,
                                  'userId': _selectedMessageUserId,
                                  'name': _messageToReplyUserName,
                                  'message': _messageToReply,
                                  'mediaLink': _mediaToReply,
                                }
                              : null,
                          'file': null,
                        };

                        context
                            .read<ChatGroupCubit>()
                            .sendMessage(payload, true);
                        isReply = false;

                        messageEC.clear();
                        _mediaToReply = null;
                        _messageToReply = null;
                        _selectedMessageId = null;
                        _messageToReplyUserName = null;
                        _selectedMessageUserId = null;

                        imageToUpload = null;
                        _videoFile = null;
                        _pickedFile = null;
                      }
                    }
                  },
                  child: Opacity(
                    opacity: (isCommentFilled ||
                            imageToUpload != null ||
                            _videoFile != null ||
                            _pickedFile != null)
                        ? 1
                        : 0.3,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: (isCommentFilled ||
                                imageToUpload != null ||
                                _videoFile != null ||
                                _pickedFile != null)
                            ? AppColors.primaryColor
                            : Colors.grey[500],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

// CLEAR REPLY
  void _clearReply() {
    setState(() {
      _messageToReply = null;
      _messageToReply = null;
      _selectedMessageId = null;
      _messageToReplyUserName = null;
      _selectedMessageUserId = null;
      isReply = false;
      FocusScope.of(context).unfocus();
    });
  }

  // CHAT MESSAGE CARD
  // NEED TO IMPROVE THE MESSAGE WIDGET
  Widget ChatMessageGroupWidget({
    required ChatMessageModel message,
    required bool isCurrentUser,
    required bool isAdmin,
    required bool isSenderAdmin,
    required String senderProfilePic,
    required bool isNewMsg,
  }) {
    if (message.isDeleted) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment:
              message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "This message was deleted",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onLongPress: () {
        showMessageOptions(
          context: context,
          messageId: message.id,
          isAdmin: isAdmin,
          isPin: message.isPinned,
          isOwnMessage: message.isMine,
          onPin: () {
            FocusScope.of(context).unfocus();
            BlocProvider.of<PinMessageBloc>(context).add(
              PinnedAMessagesEvent(
                messageId: message.id,
              ),
            );
          },
        );
      },
      child: SwipeTo(
        // swipeSensitivity: 5,
        onRightSwipe: (details) {
          setState(() {
            isReply = true;
            _messageToReplyUserName = message.author!.name;
            _selectedMessageUserId = message.author?.id;
            _selectedMessageId = message.id;
            _messageToReply = message.text;
            _mediaToReply = message.pictureUrl;
          });

          Future.delayed(Duration(milliseconds: 100), () {
            if (mounted) {
              FocusScope.of(context).requestFocus(messageFocusNode);
            }
          });
        },
        child: Container(
          color: isCurrentUser
              ? AppColors.transparentColor
              : AppColors.transparentColor,
          width: double.infinity,
          child: Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Align(
                alignment: isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: isCurrentUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isCurrentUser && isNewMsg)
                      GestureDetector(
                        onTap: () {
                          context
                              .push('/userProfileScreen/${message.author?.id}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: senderProfilePic != ''
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(senderProfilePic),
                                  radius: 16,
                                  backgroundColor: AppColors.greyColor,
                                )
                              : SvgPicture.asset(
                                  'assets/default-icon.svg',
                                  height: 26,
                                  width: 26,
                                ),
                        ),
                      ),
                    if (!isCurrentUser && !isNewMsg)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    Column(
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // MESSAGE CARD
                        Container(
                          margin: EdgeInsets.only(bottom: 4, right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                            minWidth: 80,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.grey.shade300
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                              topLeft: !isCurrentUser && isNewMsg
                                  ? Radius.zero
                                  : const Radius.circular(10),
                              topRight: isCurrentUser && isNewMsg
                                  ? Radius.zero
                                  : const Radius.circular(10),
                              bottomLeft: const Radius.circular(10),
                              bottomRight: const Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SENDER NAME
                              if (!isCurrentUser)
                                GestureDetector(
                                  onTap: () {
                                    context.push(
                                        '/userProfileScreen/${message.author?.id}');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        message.author?.name ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      // CHECK IF SENDER IS AN ADMIN
                                      if (isSenderAdmin) isAdminBubble(),
                                    ],
                                  ),
                                ),

                              // SHOW REPLIED MESSAGE
                              if (message.reply != null)
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border(
                                      left: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 4,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.reply!.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              message.reply!.message!,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          if (message.reply!.mediaLink != '' &&
                                              message.reply!.mediaLink != null)
                                            SizedBox(
                                              height: 50,
                                              child: MediaMessageWidget(
                                                fileUrl:
                                                    message.reply!.mediaLink!,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              // SHOW IMAGE MEDIA
                              if (message.pictureUrl != '' &&
                                  message.pictureUrl != null)
                                MediaMessageWidget(
                                  fileUrl: message.pictureUrl!,
                                ),
                              // SHOW ACTUAL MESSAGE
                              if (message.text != '')
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Linkify(
                                    options: LinkifyOptions(
                                      looseUrl: true,
                                    ),
                                    onOpen: (link) async {
                                      if (await canLaunchUrl(
                                          Uri.parse(link.url))) {
                                        await launchUrl(Uri.parse(link.url),
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        throw "Could not launch ${link.url}";
                                      }
                                    },
                                    text: message.text,
                                    style: const TextStyle(fontSize: 16),
                                    linkStyle: const TextStyle(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    convertToIndianTime(message.date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  message.isPinned
                                      ? Icon(
                                          Icons.push_pin,
                                          size: 16,
                                          color: Colors.grey,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
// SHOW MESSAGE OPTIONS

  void showMessageOptions({
    required BuildContext context,
    required String messageId,
    required bool isAdmin,
    required bool isOwnMessage,
    required bool isPin,
    required VoidCallback onPin,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            if (isAdmin)
              BlocConsumer<PinMessageBloc, PinMessagesState>(
                listener: (context, state) {
                  if (state is PinMessagesStateFailureState) {
                    Navigator.pop(context);
                    showSnackBar(
                      context: context,
                      message: "oops something went wrong!",
                    );
                  } else if (state is PinMessagesStateSuccessState) {
                    chatGroupCubit.updateMessageForPinned(messageId, !isPin);
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  if (state is PinMessagesStateLoadingState) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: CustomCircularIndicator(),
                        ),
                      ],
                    );
                  }
                  return ListTile(
                    leading: Icon(
                      isPin ? Icons.push_pin : Icons.push_pin_outlined,
                    ),
                    title: isPin ? Text('Unpin Message') : Text('Pin Message'),
                    onTap: () {
                      onPin();
                    },
                  );
                },
              ),
            if (isOwnMessage || isAdmin)
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete Message'),
                onTap: () {
                  context.read<ChatGroupCubit>().deleteMessage(
                        groupId: widget.roomId,
                        messageId: messageId,
                      );
                  // Handle delete message logic
                  Navigator.pop(context);
                },
              ),
            if (!isOwnMessage)
              ListTile(
                leading: Icon(Icons.report),
                title: Text('Report Message'),
                onTap: () {
                  Navigator.pop(context);
                  reportReasonBottomSheet(context, messageId);
                },
              ),
          ],
        );
      },
    );
  }

  // REPORT REASON BOTTOM SHEET
  Future<dynamic> reportReasonBottomSheet(
    BuildContext context,
    String messageId,
  ) {
    // LIST OF REPORT REASON
    List<String> reportReasons = [
      AppLocalizations.of(context)!.inappropriate_content,
      AppLocalizations.of(context)!.spam,
      AppLocalizations.of(context)!.harassment_or_hate_speech,
      AppLocalizations.of(context)!.violence_or_dangerous_organizations,
      AppLocalizations.of(context)!.intellectual_property_violation,
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocConsumer<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            // REPORT POST SUCCESS STATE
            if (state is ReportPostSuccessState) {
              Navigator.of(context).pop();
              reportConfirmationBottomSheet(context);
            }

            // REPORT POST FAILURE STATE
            else if (state is ReportPostFailureState) {
              Navigator.of(context).pop();
              showSnackBar(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // REPORT POST LOADING STATE
                    state is ReportPostLoadingState
                        ? const CustomCircularIndicator()
                        : Center(
                            child: Text(
                              AppLocalizations.of(context)!.reason_to_report,
                              style: onboardingHeading2Style,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'message',
                                postId: messageId,
                                reason: reportReasons[0],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[0],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'message',
                                postId: messageId,
                                reason: reportReasons[1],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[1],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'message',
                                postId: messageId,
                                reason: reportReasons[2],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[2],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'message',
                                postId: messageId,
                                reason: reportReasons[3],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[3],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'message',
                                postId: messageId,
                                reason: reportReasons[4],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[4],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// REPORT POST CONFIRMATION BOTTOM SHEET
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          if (context.mounted) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        });
        return Container(
          color: AppColors.whiteColor,
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/report_confirmation.png'),
              Text(
                AppLocalizations.of(context)!.thanks_for_letting_us_know,
                style: onboardingHeading2Style,
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)!
                    .we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly,
                style: blackonboardingBody1Style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // ADMIN BUBBLE
  Widget isAdminBubble() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Admin",
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  // SHOW JOIN COMMUNITY BOTTOM SHEET
  void _showJoinGroupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/chat-icon.svg',
                height: 70,
                width: 70,
              ),

              SizedBox(height: 12),

              // TITLE
              Text(
                "Oops! You're not part of this group yet.",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              // SUBTITLE
              Text(
                "Become part of the group and join the conversation.",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),

              // CANCEL BUTTON
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text("Cancel"),
                    ),
                  ),
                  SizedBox(width: 12),
                  // JOIN GROUP BUTTOM
                  Expanded(
                    child: BlocConsumer<JoinGroupBloc, JoinGroupState>(
                      listener: (context, state) {
                        // FAILURE STATE
                        if (state is JoinGroupFailureState) {
                          if (mounted) {
                            Navigator.pop(context);
                            showSnackBar(
                              context: context,
                              message: state.error,
                            );
                          }
                        }

                        // SUCCESS STATE
                        if (state is JoinGroupSuccessState) {
                          Navigator.pop(context);
                          communityMainCubit.init();
                          context.push('/group-details/${widget.roomId}');
                          showSnackBar(
                            context: context,
                            message: AppLocalizations.of(context)!
                                .group_joined_successfully,
                          );
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is JoinGroupLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            BlocProvider.of<JoinGroupBloc>(context).add(
                              JoinGroupButtonPressedEvent(
                                communityId: widget.roomId,
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.join,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

// SHOW MEDIA OPTION
  void showMediaOption() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.image,
                  color: AppColors.blackColor,
                ),
                title: Text("Pick Image"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.videocam,
                  color: AppColors.blackColor,
                ),
                title: Text("Pick Video"),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideoFromGallery();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.insert_drive_file,
                  color: AppColors.blackColor,
                ),
                title: Text("Pick File"),
                onTap: () {
                  Navigator.pop(context);
                  pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
