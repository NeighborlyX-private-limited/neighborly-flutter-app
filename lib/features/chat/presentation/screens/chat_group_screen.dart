import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_sizedbox.dart';
import '../../../../core/widgets/menu_icon_widget.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../../communities/presentation/bloc/bloc/join_group_bloc.dart';
import '../../../communities/presentation/bloc/communities_main_cubit.dart';
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
  final List<UserSimpleModel> admins;
  final List<UserSimpleModel> members;

  const ChatGroupScreen({
    super.key,
    required this.roomId,
    required this.chatRoom,
    required this.members,
    required this.admins,
  });

  @override
  State<ChatGroupScreen> createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatGroupCubit chatGroupCubit;
  late CommunityMainCubit communityMainCubit;

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
  String? _messageToReplyUserName;

  bool _isLoadingMore = false;

  final bool _shouldScrollToBottom = true;
  double _previousScrollOffset = 0.0;

  OverlayEntry? _overlayEntry;
  // INIT STATE
  @override
  void initState() {
    super.initState();

    getCurrentUserId();

    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    chatGroupCubit = BlocProvider.of<ChatGroupCubit>(context);
    chatGroupCubit.init(widget.roomId);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.minScrollExtent &&
          !_isLoadingMore) {
        _loadMoreMessages();
      }
    });
  }

// GET CURRENT USER ID
  void getCurrentUserId() {
    cuurentUserId = ShardPrefHelper.getUserID() ?? '';
  }

// CHECK IF CURRENT USER IS AN ADMIN
  bool isCurrentUserAdmin() {
    return widget.admins.any((admin) => admin.id == cuurentUserId);
  }

// CHECK IF SENDER USER IS AN ADMIN
  bool isSenderAnAdmin(String userId) {
    return widget.admins.any((admin) => admin.id == userId);
  }

// GET THE PROFILE PIC OF THE SENDER
  String getSenderProfilePic(String userId) {
    final member = widget.members.firstWhere(
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

  // / scroll to bottom
  // void _scrollToBottom() {
  //   if (_scrollController.hasClients && _shouldScrollToBottom) {
  //     Future.delayed(Duration(milliseconds: 100), () {
  //       final maxScrollExtent = _scrollController.position.maxScrollExtent;
  //       final targetOffset = (_previousScrollOffset <= maxScrollExtent)
  //           ? _previousScrollOffset
  //           : maxScrollExtent;

  //       _scrollController.position.animateTo(
  //         targetOffset,
  //         duration: Duration(milliseconds: 100),
  //         curve: Curves.easeOut,
  //       );
  //     });
  //   }
  // }

  void _scrollToBottom() {
    if (_scrollController.hasClients && _shouldScrollToBottom) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.position.animateTo(
          _previousScrollOffset,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  /// SCROLL TO END
  // void _scrollToEnd() {
  //   if (_scrollController.hasClients) {
  //     Future.delayed(Duration(milliseconds: 100), () {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: Duration(milliseconds: 100),
  //         curve: Curves.easeOut,
  //       );
  //       setState(() {
  //         _previousScrollOffset = _scrollController.position.maxScrollExtent;
  //       });
  //     });
  //   }
  // }

  /// scroll to end
  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;

      // Check if scroll controller position is at the bottom
      if (maxScroll > 0) {
        _scrollController.animateTo(
          maxScroll,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );

        setState(() {
          _previousScrollOffset = maxScroll;
        });
      }
    }
  }

  // LOAD MORE MESSAGE
  Future<void> _loadMoreMessages() async {
    setState(() {
      _isLoadingMore = true;
      // _shouldScrollToBottom = false;
    });

    // Fetch older messages from server via ChatGroupCubit
    await context.read<ChatGroupCubit>().fetchOlderMessages();
    // Restore the previous scroll position after loading more messages
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_previousScrollOffset + 500);
    // });
    setState(() {
      _isLoadingMore = false;
    });
  }

  // DISPOSE
  @override
  void dispose() {
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

  // MESSAGE INPUT AREA
  Widget messageInputSection() {
    // String? imgUrl;
    // String? videoUrl;
    // bool isImageUploading = false;
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
            // BlocListener<UploadFileBloc, UploadFileState>(
            BlocConsumer<UploadFileBloc, UploadFileState>(
              listener: (context, state) {
                if (state is UploadFileFailureState) {
                  isReply = false;

                  messageEC.clear();

                  _messageToReply = null;
                  _selectedMessageId = null;
                  _messageToReplyUserName = null;
                  _selectedMessageUserId = null;

                  imageToUpload = null;
                  _videoFile = null;
                  _pickedFile = null;

                  showSnackBar(context: context, message: state.error);
                }

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
                              'media': null,
                            }
                          : null,
                      'file': fileUrl,
                    };

                    context.read<ChatGroupCubit>().sendMessage(payload, true);

                    isReply = false;

                    messageEC.clear();

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
              builder: (context, state) {
                if (state is UploadFileLoadingState) {
                  return CustomCircularIndicator();
                }
                return InkWell(
                  onTap: () async {
                    if (!widget.chatRoom.isJoined) {
                      _showJoinGroupBottomSheet(context);
                    } else {
                      // if (imageToUpload != null) {
                      //   context
                      //       .read<UploadFileBloc>()
                      //       .add(UploadFilePressedEvent(file: imageToUpload!));
                      // }
                      if (messageEC.text.trim() != "") {
                        final payload = {
                          'groupId': widget.roomId,
                          'message': messageEC.text,
                          'repliedTo': isReply
                              ? {
                                  'messageId': _selectedMessageId,
                                  'userId': _selectedMessageUserId,
                                  'name': _messageToReplyUserName,
                                  'message': _messageToReply,
                                  'media': null,
                                }
                              : null,
                          'file': null,
                        };

                        context
                            .read<ChatGroupCubit>()
                            .sendMessage(payload, true);
                        isReply = false;

                        messageEC.clear();

                        _messageToReply = null;
                        _selectedMessageId = null;
                        _messageToReplyUserName = null;
                        _selectedMessageUserId = null;

                        imageToUpload = null;
                        _videoFile = null;
                        _pickedFile = null;
                      }
                    }
                    // if (imageToUpload != null) {
                    //   context
                    //       .read<UploadFileBloc>()
                    //       .add(UploadFilePressedEvent(file: imageToUpload!));
                    // } else if (_videoFile != null) {
                    //   context
                    //       .read<UploadFileBloc>()
                    //       .add(UploadFilePressedEvent(file: _videoFile!));
                    // } else if (_pickedFile != null) {
                    //   context
                    //       .read<UploadFileBloc>()
                    //       .add(UploadFilePressedEvent(file: _pickedFile!));
                    // } else {
                    //   if (messageEC.text.trim() != "") {
                    //     final payload = {
                    //       'groupId': widget.roomId,
                    //       'message': messageEC.text,
                    //       'repliedTo': isReply
                    //           ? {
                    //               'messageId': _selectedMessageId,
                    //               'userId': _selectedMessageUserId,
                    //               'name': _messageToReplyUserName,
                    //               'message': _messageToReply,
                    //               'media': null,
                    //             }
                    //           : null,
                    //       'file': imgUrl,
                    //     };

                    //     context
                    //         .read<ChatGroupCubit>()
                    //         .sendMessage(payload, true);

                    //     imageToUpload = null;
                    //     _selectedMessageId = null;
                    //     _messageToReply = null;
                    //     _messageToReplyUserName = null;
                    //     isReply = false;
                    //     messageEC.clear();
                    //     _videoFile = null;
                    //     _pickedFile = null;
                    //   }
                    // }
                    // }
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

  void showMediaOption() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image, color: Colors.blue),
                title: Text("Pick Image"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: Colors.red),
                title: Text("Pick Video"),
                // onTap: () => _pickVideo(),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideoFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.green),
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

  // static Future<void> _pickImage(BuildContext context) async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   Navigator.pop(context, image?.path);
  // }

  // static Future<void> _pickVideo(BuildContext context) async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
  //   Navigator.pop(context, video?.path);
  // }

  // static Future<void> _pickFile(BuildContext context) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   Navigator.pop(context, result?.files.single.path);
  // }

  String formatDate(String dateStr) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd");
      DateFormat dateFormat = DateFormat('d MMMM yyyy');
      DateTime dateTime = format.parse(dateStr);

      return dateFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  String onlyDate(String dateStr) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime dateTime = format.parse(dateStr);

      return dateFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  /// pinned message area
  // Widget pinnedMessageArea(List<PinnedMessageModel> pinnedMessages) {
  //   return Column(
  //     children: pinnedMessages
  //         .map((pinMsg) => ChatMessagePinnedWidget(
  //               message: pinMsg,
  //               // isAdmin: false,
  //               onClose: () {
  //                 setState(() {
  //                   showPinned = false;
  //                 });
  //               },
  //               // onUnpin: (messageTobeUnPinned) {
  //               //   setState(() {
  //               //     showPinned = false;
  //               //   });
  //               // },
  //             ))
  //         .toList(),
  //   );
  // }

  /// show join group sheet
  void _showJoinGroupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
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

              // Title
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

              // Subtitle
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

              // Buttons
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
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        joinGroupBottomSheet(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Join Group",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      ),
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

  /// join group bottom sheet
  Future<dynamic> joinGroupBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      useRootNavigator: true,
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.join_Community,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_join_this_community,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Confirm Button
                  Expanded(
                    child: BlocConsumer<JoinGroupBloc, JoinGroupState>(
                      listener: (context, state) {
                        /// failure state
                        if (state is JoinGroupFailureState) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .something_went_wrong,
                                ),
                              ),
                            );
                          }
                        }

                        /// success state
                        if (state is JoinGroupSuccessState) {
                          communityMainCubit.init();
                          context.push('/group-details/${widget.roomId}');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .group_joined_successfully,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is JoinGroupLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<JoinGroupBloc>(context)
                                .add(JoinGroupButtonPressedEvent(
                              communityId: widget.roomId,
                            ));
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

  /// NO message screen
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

  // BUILD
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_overlayEntry == null) {
          context.read<ChatGroupCubit>().disconnectChat(widget.roomId);
          Navigator.pop(context);
        }
        if (_overlayEntry != null) {
          _removeOverlay();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackgroundColor,
        // APPBAR AREA
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.whiteColor,
          title: appBarTitleArea(),
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
            IconButton(
              onPressed: () {
                // DO SOME ACTION ONTAP MENU ICON
              },
              icon: Icon(
                Icons.more_vert_outlined,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        // BODY AREA
        body: BlocConsumer<ChatGroupCubit, ChatGroupState>(
          // BLOC LISTENER
          listener: (context, state) {
            // FAILURE STATE
            if (state.status == Status.failure) {
              showSnackBar(
                context: context,
                message: state.failure?.message ?? 'oops something went wrong',
              );
            }
            // SUCCESS STATE WITH IS LOADING FALSE
            if (state.status == Status.success && !_isLoadingMore) {
              // _shouldScrollToBottom = true;
              // _scrollToBottom();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToEnd();
              });
            }
            // if (state.status == Status.success && state.page == 1) {

            //   // _scrollToEnd();
            //   Future.delayed(Duration(milliseconds: 100), () {
            //     if (_scrollController.hasClients) {
            //       _scrollToEnd();
            //     }
            //   });
            // }
            /// success state
            if (state.status == Status.success && state.page == 1) {
              // Ensure the scroll action occurs after the widget layout is completed
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToEnd();
              });
            }
            // if (state.status == Status.success) {
            // var newPinnedMessages = <ChatMessageModel>[];
            // pinnedMessages = [
            //   ...state.messages.where(
            //     (element) => !element.isPinned,
            //   )
            // ];
            // }
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
            return RefreshIndicator(
              onRefresh: () async {
                chatGroupCubit.init(widget.roomId);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // SHOW LOADING ON THE TOP OF THE SCREEN WHEN FEATCHING OLD MESSAGES
                  if (_isLoadingMore)
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomCircularIndicator(),
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
                                message: 'message pinned',
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
                              itemCount: state.messages.length +
                                  (_isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= state.messages.length) {
                                  return SizedBox.shrink();
                                }
                                // CHECK IF THE CURRENT AND PRIVIOUS MESSAGE SENDER IS SAME OR NOT
                                var msg = state.messages[index];
                                final bool isNewMsg = index == 0 ||
                                    msg.author?.id !=
                                        state.messages[index - 1].author?.id;

                                // CHECK SENDER USER IS ADMIN OR NOT
                                final bool isSenderAdmin =
                                    isSenderAnAdmin(msg.author!.id);

                                // CHECK CURRENT USER IS ADMIN OR NOT
                                final bool isAdmin = isCurrentUserAdmin();

                                // GET PROFILE PIC OF THE  SENDER USER
                                final String senderProfilePic =
                                    getSenderProfilePic(msg.author!.id);

                                // NEED TO THINK ABOUT THIS LINE
                                if (_isLoadingMore &&
                                    index == state.messages.length) {
                                  return CustomCircularIndicator();
                                }

                                return ChatMessageGroupWidget(
                                  message: msg,
                                  isCurrentUser:
                                      (msg.author?.id == cuurentUserId),
                                  isAdmin: isAdmin,
                                  isNewMsg: isNewMsg,
                                  isSenderAdmin: isSenderAdmin,
                                  senderProfilePic: senderProfilePic,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Text(
                              '$_messageToReply',
                              style: TextStyle(
                                color: AppColors.blackColor,
                              ),
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
                                width: 250,
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
              ),
            );
          },
        ),
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
          UserAvatarStyledWidget(
            avatarUrl: widget.chatRoom.avatarUrl,
            avatarSize: 19,
            avatarBorderSize: 0,
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

// CLEAR REPLY
  void _clearReply() {
    setState(() {
      _messageToReply = null;
      _selectedMessageId = null;
      _messageToReplyUserName = null;
      _selectedMessageUserId = null;
      isReply = false;
      FocusScope.of(context).unfocus();
      // FocusScope.of(context).requestFocus(messageFocusNode);
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
    return GestureDetector(
      onLongPress: () {
        if (isAdmin) {
          showPinMessageDialog(
            context: context,
            message: message,
            onPin: () {
              BlocProvider.of<PinMessageBloc>(context).add(
                PinnedAMessagesEvent(
                  messageId: message.id,
                ),
              );
            },
          );
        }
      },
      child: SwipeTo(
        onRightSwipe: (details) {
          setState(() {
            isReply = true;
            _messageToReplyUserName = message.author!.name;
            _selectedMessageUserId = message.author?.id;
            _selectedMessageId = message.id;
            _messageToReply = message.text;
          });
          FocusScope.of(context).requestFocus(messageFocusNode);
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: senderProfilePic != ''
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(senderProfilePic),
                                radius: 16,
                                backgroundColor: AppColors.greyColor,
                              )
                            : SvgPicture.asset(
                                'assets/default-icon.svg',
                                height: 26,
                                width: 26,
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
                                Row(
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
                              // SHOW IMAGE MEDIA
                              if (message.pictureUrl != '' &&
                                  message.pictureUrl != null)
                                MediaMessageWidget(
                                  fileUrl: message.pictureUrl!,
                                ),

                              // SHOW REPLIED MESSAGE
                              if (message.reply != null)
                                Container(
                                  //width: double.infinity,
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
                                      Text(
                                        message.reply!.message!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
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
                              Text(
                                convertToIndianTime(message.date),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45,
                                ),
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

// PINNED MESSAGE POP UP
  void showPinMessageDialog({
    required BuildContext context,
    required ChatMessageModel message,
    required VoidCallback onPin,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final double maxHeight = MediaQuery.of(context).size.height * 0.7;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return BlocConsumer<PinMessageBloc, PinMessagesState>(
                listener: (context, state) {
                  if (state is PinMessagesStateFailureState) {
                    Navigator.pop(context);
                    showSnackBar(
                        context: context,
                        message: "oops something went wrong!");
                  } else if (state is PinMessagesStateSuccessState) {
                    showSnackBar(
                        context: context,
                        message: "Message pinned successfully!");
                  }
                },
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    constraints: BoxConstraints(
                      maxHeight: maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Linkify(
                                options: LinkifyOptions(
                                  looseUrl: true,
                                ),
                                onOpen: (link) async {
                                  if (await canLaunchUrl(Uri.parse(link.url))) {
                                    await launchUrl(Uri.parse(link.url),
                                        mode: LaunchMode.externalApplication);
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
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.cancel,
                                color: AppColors.greyColor,
                              ),
                              label: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                onPin();
                              },
                              icon: Icon(
                                Icons.push_pin,
                                color: AppColors.primaryColor,
                              ),
                              label: Text(
                                "Pin Message",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay(BuildContext context, ChatMessageModel message) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) return; // Prevent crash
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          // setState(() {
          //   showReplyInput = false;
          // });
          _removeOverlay();
        },
        child: Material(
          child: Container(
            color: Colors.black54,
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: UserAvatarStyledWidget(
                            avatarUrl: message.author!.avatarUrl,
                            avatarBorderSize: 0,
                            avatarSize: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      message.author?.name ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      convertToIndianTime(
                                        message.date,
                                      ),
                                      // DateUtilsHelper
                                      //     .simplifyISOtimeStringOnlyHour(
                                      //         widget.message.date),
                                      // formatTime(widget.message.date),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    if (message.author?.isAdmin == true ||
                                        message.isAdmin == true) ...[
                                      isAdminBubble(),
                                    ],
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              // showReplyInput = false;
                                              // FocusScope.of(context).requestFocus(messageFocusNode);
                                            });
                                            _removeOverlay();
                                          },
                                          child: Icon(Icons.close),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                    color: AppColors.whiteColor,
                                    width: MediaQuery.of(context).size.width,
                                    child: message.pictureUrl != '' &&
                                            message.text == ''
                                        ? Image.network('${message.pictureUrl}')
                                        : Linkify(
                                            options: LinkifyOptions(
                                              looseUrl: true,
                                            ),
                                            onOpen: (link) async {
                                              if (await canLaunchUrl(
                                                  Uri.parse(link.url))) {
                                                await launchUrl(
                                                    Uri.parse(link.url),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              } else {
                                                throw "Could not launch ${link.url}";
                                              }
                                            },
                                            text: message.text,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            linkStyle: const TextStyle(
                                              color: AppColors.primaryColor,
                                            ),
                                          )
                                    // : Text(
                                    //     widget.message.text,
                                    //     textAlign: TextAlign.start,
                                    //     style: TextStyle(
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.normal,
                                    //     ),
                                    //   ),
                                    ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // menu area
                  Container(
                    height:
                        // showReplyInput
                        //     ? MediaQuery.of(context).size.height * 0.10
                        //     :
                        MediaQuery.of(context).size.height * 0.40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (true) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 5,
                                  width: 40,
                                  margin: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // reactionCircle(
                                  //   assetUrl: 'assets/react5.svg',
                                  //   onTap: () {
                                  //     _updateState('cheer');
                                  //     widget.onTapCheer();
                                  //     _removeOverlay();
                                  //   },
                                  // ),
                                  // reactionCircle(
                                  //   assetUrl: 'assets/react6.svg',
                                  //   onTap: () {
                                  //     _updateState('boo');
                                  //     widget.onTapBool();
                                  //     _removeOverlay();
                                  //   },
                                  // ),
                                  // reactionCircle(
                                  //   assetUrl: 'assets/Local_Legend.svg',
                                  //   onTap: () {
                                  //     // Function(String, String)?
                                  //     widget.onReact(
                                  //         widget.message.id, 'Local Legend');
                                  //     _removeOverlay();
                                  //   },
                                  // ),
                                  // reactionCircle(
                                  //   assetUrl: 'assets/Sunflower.svg',
                                  //   onTap: () {
                                  //     widget.onReact(
                                  //         widget.message.id, 'Sunflower');
                                  //     _removeOverlay();
                                  //   },
                                  // ),
                                  // reactionCircle(
                                  //   assetUrl: 'assets/Streetlight.svg',
                                  //   onTap: () {
                                  //     widget.onReact(
                                  //         widget.message.id, 'Streetlight');
                                  //     _removeOverlay();
                                  //   },
                                  // ),
                                  // reactionCircle(
                                  //   assetUrl: 'assets/Park_Bench.svg',
                                  //   onTap: () {
                                  //     widget.onReact(
                                  //         widget.message.id, 'Park Bench');
                                  //     _removeOverlay();
                                  //   },
                                  // ),
                                  // reactionCircle(
                                  //   assetUrl: 'assets/Map.svg',
                                  //   onTap: () {
                                  //     widget.onReact(widget.message.id, 'Map');
                                  //     _removeOverlay();
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                            //const SizedBox(height: 20),
                            if (message.isAdmin == true)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: MenuIconItem(
                                    title: 'Pinned message',
                                    svgPath: 'assets/pinned.svg',
                                    iconSize: 25,
                                    onTap: () {
                                      //widget.onTapPinned(widget.message.id);
                                      _removeOverlay();
                                      BlocProvider.of<PinMessageBloc>(context)
                                          .add(
                                        PinnedAMessagesEvent(
                                          messageId: message.id,
                                        ),
                                      );
                                      //widget.onTapReply(widget.message);
                                      // _removeOverlay();
                                    }),
                              ),
                            //const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MenuIconItem(
                                  title: 'See Replies',
                                  svgPath: 'assets/menu_reply_list.svg',
                                  iconSize: 25,
                                  onTap: () {
                                    context.push(
                                        '/group-chat-thread/${message.id}',
                                        extra: {
                                          'message': message,
                                          'room': widget.chatRoom,
                                        });
                                    //widget.onTapReply(widget.message);
                                    _removeOverlay();
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MenuIconItem(
                                  title: 'Reply',
                                  svgPath: 'assets/menu_reply.svg',
                                  iconSize: 25,
                                  onTap: () {
                                    setState(() {
                                      //widget.onTapReply(widget.message);
                                      //showReplyInput = true;
                                      // FocusScope.of(context).requestFocus(messageFocusNode);
                                      _removeOverlay();
                                      context.push(
                                          '/group-chat-thread/${message.id}',
                                          extra: {
                                            'message': message,
                                            'room': widget.chatRoom,
                                          });
                                    });

                                    // setState(() {
                                    //   if (messageFocusNode.canRequestFocus) {
                                    //     messageFocusNode.requestFocus();
                                    //   }
                                    //   // FocusScope.of(context).requestFocus(messageFocusNode);
                                    // });
                                    // _showOverlay(context);
                                  }),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 8.0),
                            //   child: MenuIconItem(
                            //       title: 'Share',
                            //       svgPath: 'assets/menu_share.svg',
                            //       iconSize: 25,
                            //       onTap: () {
                            //         // communityDetailCubit.toggleMute();
                            //         widget.onShare(widget.message);

                            //         setState(() {
                            //           showReplyInput = false;
                            //         });
                            //         _removeOverlay();
                            //       }),
                            // ),

                            /// show pinned option
                            // if (widget.isAdmin == true)
                            //   Padding(
                            //     padding: const EdgeInsets.only(left: 8.0),
                            //     child: MenuIconItem(
                            //         title: 'Pinned Message',
                            //         svgPath: 'assets/menu_pinned.svg',
                            //         iconSize: 25,
                            //         textColor: Colors.black,
                            //         onTap: () {
                            //           setState(() {
                            //             showReplyInput = false;
                            //           });
                            //           _removeOverlay();
                            //           widget.onPin(widget.message);
                            //         }),
                            //   ),

                            /// report msg
                            if (message.isAdmin == false)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: MenuIconItem(
                                    title: 'Report',
                                    svgPath: 'assets/menu_report_core.svg',
                                    iconSize: 25,
                                    textColor: Colors.red,
                                    onTap: () {
                                      // setState(() {
                                      //   showReplyInput = false;
                                      // });
                                      _removeOverlay();
                                      reportReasonBottomSheet(context);
                                    }),
                              ),
                          ],
                          // if (showReplyInput == true) ...[
                          //   messageInputSection(),
                          // ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // REPORT MESSAGE BOTTOM SHEET
  Future<dynamic> reportReasonBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xffB8B8B8),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'Reason to Report',
                    style: onboardingHeading2Style,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...kReportReasons.map(
                      (e) => InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();

                          await reportConfirmationBottomSheet(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e,
                                style: blackonboardingBody1Style,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// CONFIRM REPORT BOTTOM SHEET
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Image.asset('assets/report_confirmation.png'),
              Text(
                'Thanks for letting us know',
                style: onboardingHeading2Style,
              ),
              Text(
                textAlign: TextAlign.center,
                'We appreciate your help in keeping our community safe and respectful. Our team will review the content shortly.',
                style: blackonboardingBody1Style,
              ),
            ],
          ),
        );
      },
    );
  }
}
