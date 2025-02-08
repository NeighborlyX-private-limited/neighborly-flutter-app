import 'dart:io';
import 'package:chat_message_timestamp/chat_message_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neighborly_flutter_app/core/utils/video_compresser.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/utils/uploade_file.dart';
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
  final String roomId;
  final ChatRoomModel room;
  final List admin;
  final List member;

  const ChatGroupScreen({
    super.key,
    required this.roomId,
    required this.room,
    required this.member,
    required this.admin,
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
  bool isCommentFilled = false;
  bool showPinned = true;
  File? fileToUpload;
  File? _videoFile;
  File? _pickedFile;
  bool isReply = false;
  String? _selectedMessageId;
  String? _messageToReply;
  String? base64File;
  bool _isLoadingMore = false;
  OverlayEntry? _overlayEntry;
  bool _shouldScrollToBottom = true;
  double _previousScrollOffset = 0.0;
  String cuurentUserId = '';

  /// init state method
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

  void getCurrentUserId() {
    cuurentUserId = ShardPrefHelper.getUserID() ?? '';
    print('cuurentUserId:$cuurentUserId');
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

  /// load more msg
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

  /// member is not part of the group and try to send msg
  void ShowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          title: Column(
            children: [
              SvgPicture.asset(
                'assets/event-coming-soon.svg',
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Text(
                'Only group member can reply to the messages in this group',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Join Now',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// dispose method
  @override
  void dispose() {
    chatGroupCubit.setPagetoDefault();
    messageEC.dispose();
    super.dispose();
  }

  /// pic image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery).then((file) {
      return compressImage(imageFileX: file);
    });

    if (image != null) {
      print('fileToUpload before: $fileToUpload');
      setState(() {
        fileToUpload = File(image.path);
      });
      print('fileToUpload after: $fileToUpload');
    }
  }

  /// pic image
  Future<void> pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickMedia();

    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile.path);
        print('pickedFile:$pickedFile');
        // fileToUpload = File(image.path);
      });
    }
  }

  /// Pick video from gallery
  Future<void> _pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      // Start loading
      // setState(() {
      //   isImagePicking = true;
      // });

      // Pick video from gallery
      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
      );
      print('pickedVideoFile $pickedFile');
      // Check if a video is picked
      if (pickedFile != null) {
        // Get picked video path
        print('_videoFile 1 $_videoFile');
        setState(() {
          _videoFile = File(pickedFile.path);
        });
        print('_videoFile 2 $_videoFile');
        //await _generateVideoThumbnail(_videoFile!.path);

        // Calculate video size
        // int fileSizeInBytes = _videoFile!.lengthSync();
        // double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        // if (fileSizeInMB > 50) {
        //   if (mounted) {
        //     showSnackBar(
        //       context: context,
        //       message: AppLocalizations.of(context)!.this_video_is_too_large,
        //     );
        //   }
        //   setState(() {
        //     _videoFile = null;
        //   });
        //   return;
        // }

        // Compress video
        // _videoFile = await compressVideo(_videoFile!);

        // Validate compressed video size
        // int compressedFileSizeInBytes = _videoFile!.lengthSync();
        // double compressedFileSizeInMB =
        //     compressedFileSizeInBytes / (1024 * 1024);

        // if (compressedFileSizeInMB > 15) {
        //   if (mounted) {
        //     showSnackBar(
        //       context: context,
        //       message: AppLocalizations.of(context)!.this_video_is_too_large,
        //     );
        //   }
        //   setState(() {
        //     _videoFile = null;
        //   });

        //   return;
        // }

        // Initialize video controller
        // _videoController = VideoPlayerController.file(_videoFile!)
        //   ..initialize().then((_) {
        //     setState(() {}); // Refresh the UI after initialization
        //     _videoController!.pause();
        //   });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in video picking: $e')),
        );
      }
    } finally {
      // Stop loading
      setState(() {
        // _videoFile = null;
        // isPollOptionShow = true;
      });
    }
  }

  /// pic video
  // Future<void> pickVideo() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image =
  //       await picker.pickVideo(source: ImageSource.gallery).then((file) {
  //     return compressVideo(imageFileX: file);
  //   });

  //   if (image != null) {
  //     setState(() {
  //       fileToUpload = File(image.path);
  //     });
  //   }
  // }

  /// app bar title area
  Widget appBarTitleArea() {
    return Row(
      children: [
        GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            context.read<ChatGroupCubit>().disconnectChat(widget.roomId);
            Navigator.pop(context);
            return;
          },
        ),
        const SizedBox(
          width: 10,
        ),
        if (widget.room.avatarUrl != '')
          UserAvatarStyledWidget(
            avatarUrl: widget.room.avatarUrl,
            avatarSize: 19,
            avatarBorderSize: 0,
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.room.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// message input section area
  Widget messageInputSection() {
    String? imgUrl;
    // String? videoUrl;
    bool isImageUploading = false;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
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
                    onTap: showMediaOption,
                    // onTap: pickImage,
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

            ///send button
            // BlocListener<UploadFileBloc, UploadFileState>(
            BlocConsumer<UploadFileBloc, UploadFileState>(
              listener: (context, state) {
                if (state is UploadFileFailureState) {
                  base64File = null;
                  fileToUpload = null;
                  _selectedMessageId = null;
                  _messageToReply = null;
                  isReply = false;
                  messageEC.clear();
                  showSnackBar(context: context, message: state.error);
                }

                if (state is UploadFileSuccessState) {
                  imgUrl = state.url;
                  print('url: ${state.url}');
                  if (messageEC.text.trim() != "" || fileToUpload != null) {
                    final payload = {
                      'groupId': widget.roomId,
                      'message': messageEC.text,
                      'parentMessageId': isReply ? _selectedMessageId : null,
                      'file': imgUrl,
                    };

                    context.read<ChatGroupCubit>().sendMessage(payload, true);
                    base64File = null;
                    fileToUpload = null;
                    _videoFile = null;
                    _pickedFile = null;
                    _selectedMessageId = null;
                    _messageToReply = null;
                    isReply = false;
                    messageEC.clear();
                  }
                }
              },
              builder: (context, state) {
                if (state is UploadFileLoadingState) {
                  return CircularProgressIndicator();
                }
                return InkWell(
                  onTap: () async {
                    if (!widget.room.isJoined) {
                      _showJoinGroupBottomSheet(context);
                    } else {
                      print('video file: $_videoFile');
                      print('image file: $fileToUpload');
                      // String? imgUrl;
                      if (fileToUpload != null) {
                        context
                            .read<UploadFileBloc>()
                            .add(UploadFilePressedEvent(file: fileToUpload!));
                        //imgUrl = await uploadFile(file: fileToUpload!);
                      } else if (_videoFile != null) {
                        context
                            .read<UploadFileBloc>()
                            .add(UploadFilePressedEvent(file: _videoFile!));
                      } else if (_pickedFile != null) {
                        context
                            .read<UploadFileBloc>()
                            .add(UploadFilePressedEvent(file: _pickedFile!));
                      } else {
                        if (messageEC.text.trim() != "" ||
                            fileToUpload != null) {
                          final payload = {
                            'groupId': widget.roomId,
                            'message': messageEC.text,
                            'parentMessageId':
                                isReply ? _selectedMessageId : null,
                            'file': imgUrl,
                          };

                          context
                              .read<ChatGroupCubit>()
                              .sendMessage(payload, true);
                          base64File = null;
                          fileToUpload = null;
                          _selectedMessageId = null;
                          _messageToReply = null;
                          isReply = false;
                          messageEC.clear();
                          _videoFile = null;
                          _pickedFile = null;
                        }
                      }
                    }
                  },
                  child: Opacity(
                    opacity: (isCommentFilled ||
                            fileToUpload != null ||
                            _videoFile != null)
                        ? 1
                        : 0.3,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: (isCommentFilled ||
                                fileToUpload != null ||
                                _videoFile != null)
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
                          return CircularProgressIndicator();
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

  ///  bottom sheet method for more vert icon
  void _showBottomSheet(var roomId) {
    showModalBottomSheet(
      useRootNavigator: true,
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 30,
          ),
          child: Wrap(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.push(
                    '/group-chat-pinned-message/${widget.roomId}',
                  );
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/pinned.svg',
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Pinned message'),
                  ],
                ),
              ),
              CustomSizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  /// NO message screen
  Widget noMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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

  /// build method
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: appBarTitleArea(),
          actions: [
            IconButton(
              onPressed: () {
                _showBottomSheet(widget.roomId);
              },
              icon: Icon(
                Icons.more_vert_outlined,
                size: 31,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: BlocConsumer<ChatGroupCubit, ChatGroupState>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              showSnackBar(
                context: context,
                message: state.failure?.message ?? 'oops something went wrong',
              );
            }
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
          builder: (context, state) {
            // int lineCount = 1;
            // String lastDate = '';
            return BlocBuilder<ChatGroupCubit, ChatGroupState>(
              builder: (context, state) {
                // var pinnedMessages = <ChatMessageModel>[];

                /// loading state
                if (state.status == Status.loading) {
                  return Container(
                    color: Colors.white,
                    child: ChatMessagesGroupSheemer(),
                  );
                }

                /// get pinned msg
                // else {
                //   pinnedMessages = [
                //     ...state.messages.where((element) => !element.isPinned)
                //   ];
                // }

                return Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /// #pinned msg area
                      // if (showPinned && pinnedMessages.isNotEmpty)
                      //   pinnedMessageArea(
                      //     pinnedMessages,
                      //   ),

                      /// Show loading indicator at the top when fetching more messages
                      if (_isLoadingMore)
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      state.status == Status.success && state.messages.isEmpty
                          ? Expanded(child: noMessage())
                          : BlocListener<PinMessageBloc, PinMessagesState>(
                              listener: (context, state) {
                                if (state is PinMessagesStateSuccessState) {
                                  showSnackBar(
                                    context: context,
                                    message: 'message pinned',
                                  );
                                } else if (state
                                    is PinMessagesStateFailureState) {
                                  showSnackBar(
                                    context: context,
                                    message: state.error,
                                  );
                                }
                              },
                              child: Expanded(
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: state.messages.length +
                                        (_isLoadingMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= state.messages.length) {
                                        return SizedBox.shrink();
                                      }
                                      final bool isNewMsg = index == 0 ||
                                          state.messages[index].author?.id !=
                                              state.messages[index - 1].author
                                                  ?.id;

                                      var msg = state.messages[index];

                                      // var dateSummary = state.messages[index].date.split(" ")[0] ?? state.messages[index].date.split("T")[0];
                                      //String cheerorbooFromreply = state.messages[index].booOrCheer;

                                      // var dateSummary = onlyDate(msg.date);

                                      /// Show loading indicator at the top when fetching more messages
                                      if (_isLoadingMore &&
                                          index == state.messages.length) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return ChatMessageGroupWidget(
                                        isNewMsg: isNewMsg,
                                        message: msg,
                                        isAdmin: true,
                                        isCurrentUser:
                                            (msg.author?.id == cuurentUserId),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                      // if (fileToUpload != null)
                      //   Stack(
                      //     children: [
                      //       Positioned.fill(
                      //         child: Image.file(
                      //           fileToUpload!,
                      //           fit: BoxFit.contain,
                      //         ),
                      //       ),
                      //     ],
                      //   ),

                      if (isReply)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: Container(
                            color: Colors.grey.shade100,
                            child: Row(
                              children: [
                                Icon(Icons.reply, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text('Replying to: $_messageToReply'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: _clearReply,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (fileToUpload != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: Container(
                            color: Colors.grey.shade100,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Image.file(
                                  fileToUpload!,
                                  width: 200,
                                  height: 200,
                                )),
                                // Icon(Icons.reply, size: 20),
                                // SizedBox(width: 8),
                                // Expanded(
                                //   child: Text('Replying to: $_messageToReply'),
                                // ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      fileToUpload = null;
                                    });
                                  },
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
            );
          },
        ),
      ),
    );
  }

// clear reply
  void _clearReply() {
    setState(() {
      _selectedMessageId = null;
      _messageToReply = null;
      isReply = false;
    });
  }

  /// admin bubble widget
  Widget isAdminBubble() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        "Admin",
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// chat message group widget
  Widget ChatMessageGroupWidget({
    required bool isNewMsg,
    required ChatMessageModel message,
    required bool isAdmin,
    required bool isCurrentUser,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: InkWell(
          onLongPress: () {
            _showOverlay(context, message);
            return;
          },
          child: Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isCurrentUser && isNewMsg)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(message.author!.avatarUrl),
                    radius: 18,
                    backgroundColor: Colors.red,
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
                  /// **Sender Name & Time**
                  if (!isCurrentUser && isNewMsg)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.author?.name ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (widget.admin.contains(message.author?.id))
                          isAdminBubble(),
                      ],
                    ),

                  /// **Message Bubble**

                  SwipeTo(
                    swipeSensitivity: 5,
                    onRightSwipe: (details) {
                      setState(() {
                        isReply = true;
                        _messageToReply = message.text;
                        _selectedMessageId = message.id;
                      });
                      FocusScope.of(context).requestFocus(messageFocusNode);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 4, right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? const Color.fromARGB(255, 250, 250, 255)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10),
                          bottomLeft: isCurrentUser
                              ? const Radius.circular(10)
                              : Radius.zero,
                          bottomRight: isCurrentUser
                              ? Radius.zero
                              : const Radius.circular(10),
                        ),
                      ),

                      // child: message.text != ''
                      //     ? TimestampedChatMessage(
                      //         text: message.text,
                      //         sentAt: convertToIndianTime(message.date),
                      //       )
                      //     : SizedBox(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.pictureUrl != '')
                            MediaMessageWidget(
                              fileUrl: message.pictureUrl!,
                            ),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(10),
                          //   child: Image.network(
                          //     fit: BoxFit.fill,
                          //     '${message.pictureUrl}',
                          //   ),
                          // ),
                          // if (message.text != '')
                          // if (message.id != null)
                          //   Container(
                          //     padding: EdgeInsets.all(8),
                          //     margin: EdgeInsets.only(bottom: 5),
                          //     decoration: BoxDecoration(
                          //       color: Colors.grey.shade400,
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Text(
                          //       "ReplyinReplyinReplyingReplyingReplyinggReplyingReplyingReplyingg to:",
                          //       style: TextStyle(
                          //         fontSize: 12,
                          //         fontStyle: FontStyle.italic,
                          //         color: Colors.black54,
                          //       ),
                          //     ),
                          //   ),

                          // Actual message text
                          // Text(
                          //   message.text,
                          //   style: TextStyle(fontSize: 16),
                          // ),

                          if (message.text != '')
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
                                          'room': widget.room,
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
                                            'room': widget.room,
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

  /// report reason bottom sheet
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
