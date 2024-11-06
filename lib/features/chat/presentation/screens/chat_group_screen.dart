import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';
import '../bloc/chat_group_cubit.dart';
import '../widgets/chat_message_group_widget.dart';
import '../widgets/chat_message_pinned_widget.dart';
import '../widgets/chat_messages_group_sheemer.dart';
import '../../../../core/constants/imagepickercompress.dart';

class ChatGroupScreen extends StatefulWidget {
  final String roomId;
  final ChatRoomModel room;

  const ChatGroupScreen({
    Key? key,
    required this.roomId,
    required this.room,
  }) : super(key: key);

  @override
  State<ChatGroupScreen> createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {
  late var chatGroupCubit;

  final messageEC = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  bool isCommentFilled = false;
  bool showPinned = true;
  File? fileToUpload;
  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _shouldScrollToBottom = true;
  double _previousScrollOffset = 0.0;
  @override
  void initState() {
    super.initState();
    chatGroupCubit = BlocProvider.of<ChatGroupCubit>(context);
    chatGroupCubit.init(widget.roomId); // widget.roomId;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.minScrollExtent &&
          !_isLoadingMore) {
        _loadMoreMessages();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && _shouldScrollToBottom) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.position.jumpTo(_previousScrollOffset);
      });
    }
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        setState(() {
          _previousScrollOffset = _scrollController.position.maxScrollExtent;
        });
      });
    }
  }

  Future<void> _loadMoreMessages() async {
    double currentScrollOffset = _scrollController.offset;
    setState(() {
      _isLoadingMore = true;
      _shouldScrollToBottom = false;
      // _previousScrollOffset = _scrollController.position.pixels;
    });

    // Fetch older messages from server via ChatGroupCubit
    await context.read<ChatGroupCubit>().fetchOlderMessages();
    // Restore the previous scroll position after loading more messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_previousScrollOffset + 500);
    });
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    chatGroupCubit.setPagetoDefault();
    messageEC.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery).then((file) {
      return compressImage(imageFileX: file);
    });

    if (image != null) {
      setState(() {
        fileToUpload = File(image.path);
        print('Do something with this file: ${fileToUpload?.path}');
        // TODO: send image as message
        chatGroupCubit.sendMessage(message: '', image: fileToUpload);
      });
    }
  }

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
          child: Container(
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
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              // const SizedBox(height: 3),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text(
              //         'Online',
              //         maxLines: 1,
              //         overflow: TextOverflow.ellipsis,
              //         style: TextStyle(
              //             fontWeight: FontWeight.normal,
              //             color: Colors.black45,
              //             fontSize: 14),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          )),
        ),
      ],
    );
  }

  Widget messageInputSection() {
    // bool isReply = commentToReply != null; // Check if it's a reply
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: messageEC,
                focusNode: messageFocusNode,
                onChanged: (value) {
                  setState(() {
                    isCommentFilled = messageEC.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: pickImage,
                      child: Icon(
                        Icons.photo_camera_back_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20)),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                // #send
                // XXX
                final payload = {
                  'group_id': '${widget.roomId}',
                  'msg': messageEC.text
                };
                context.read<ChatGroupCubit>().sendMessage(payload, true);
                // fileToUpload = null;
                messageEC.clear();
              },
              child: Opacity(
                opacity: messageEC.text.isNotEmpty ? 1 : 0.3,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isCommentFilled
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
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateStr) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd"); //  HH:mm:ss
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

  Widget pinnedMessageArea(List<ChatMessageModel> pinnedMessages) {
    return Column(
      children: pinnedMessages
          .map((pinMsg) => ChatMessagePinnedWidget(
                message: pinMsg,
                isAdmin: true, // TODO: make this check real
                onClose: () {
                  setState(() {
                    showPinned = false;
                  });
                },
                onUnpin: (messageTobeUnPinned) {
                  print(
                      '#unPinned : call remote to on message: ${messageTobeUnPinned.id}');
                  setState(() {
                    showPinned = false;
                  });
                },
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: appBarTitleArea(),
        actions: [
          IconButton(
            onPressed: () {
              // TEST
              chatGroupCubit.testReceivingMessage();
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
          print('... state.currentUser: ${state.status}');

          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              // hideLoader();
              // showError(state.errorMessage ?? 'Some error');
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              // print('Success JUMP to ${state.roomId}');
              // Navigator.of(context).pop();
              // context.push('/groups/${state.roomId}');
              break;
            case Status.initial:
              break;
          }
          if (state.status == Status.success && !_isLoadingMore) {
            _shouldScrollToBottom = true;
            //_scrollToBottom();
          }
          if (state.status == Status.success && state.page == 1) {
            Future.delayed(Duration(milliseconds: 100), () {
              if (_scrollController.hasClients) {
                _scrollToEnd();
              }
            });
          }
        },
        builder: (context, state) {
          //
          //
          int lineCount = 1;
          String lastDate = '';
          return BlocBuilder<ChatGroupCubit, ChatGroupState>(
            bloc: chatGroupCubit,
            builder: (context, state) {
              var pinnedMessages = <ChatMessageModel>[];
              if (state.status == Status.loading) {
                return Container(
                    color: Colors.white, child: ChatMessagesGroupSheemer());
              } else {
                pinnedMessages = [
                  ...state.messages.where((element) => element.isPinned)
                ];
              }

              return Container(
                padding: EdgeInsets.only(top: 1),
                margin: EdgeInsets.only(top: 1),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //
                    //
                    // #pinned #pin
                    if (showPinned && pinnedMessages.length != 0)
                      pinnedMessageArea(
                        pinnedMessages,
                      ),
                    //
                    //
//                     //  TextButton(onPressed: _loadMoreMessages, child: Text('Load more messages'),
// ),
                    if (_isLoadingMore)
                      Padding(
                        padding: const EdgeInsets.all(
                          6.0,
                        ),
                        // child: Center(
                        //   child: BouncingLogoIndicator(
                        //     logo: 'images/logo.svg',
                        //   ),
                        // ),

                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    // Show loading indicator at the top when fetching more messages

                    Expanded(
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          // reverse: true, // Inverter a ordem da lista
                          itemCount:
                              state.messages.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.messages.length) {
                              return SizedBox.shrink();
                            }

                            var msg = state.messages[index];

                            // var dateSummary = state.messages[index].date.split(" ")[0] ?? state.messages[index].date.split("T")[0];

                            //String cheerorbooFromreply = state.messages[index].booOrCheer;

                            var dateSummary =
                                onlyDate(state.messages[index].date);
                            if (_isLoadingMore &&
                                index == state.messages.length) {
                              // Show loading indicator at the top when fetching more messages
                              return Center(child: CircularProgressIndicator());
                            }
                            var messageWidget = ChatMessageGroupWidget(
                              message: msg,
                              isAdmin: true, // TODO: make this a real check
                              showIsReaded:
                                  (lineCount == state.messages.length) &&
                                      msg.isMine,
                              onTap: (msgSelected) {
                                print('....selected=${msgSelected}');
                                print('lineCount=${lineCount}');
                              },
                              onReply: (msgIdToSendReply, message) {
                                print('#send reply');
                                // TODO: colocar cubit action to remote, and load thread message
                                context.push(
                                    '/chat/group/thread/${msgIdToSendReply.id}',
                                    extra: {
                                      'message': msgIdToSendReply,
                                      'room': widget.room,
                                    });
                              },
                              onTapReply: (messageToOpen) {
                                print('#onTag reply - only JUMP');
                                context.push(
                                    '/chat/group/thread/${messageToOpen.id}',
                                    extra: {
                                      'message': messageToOpen,
                                      'room': widget.room,
                                    });
                              },
                              onTapCheer: () {
                                print(
                                    '#onTap cheer - send to remote ${state.messages[index]})');
                                final payload = {
                                  'group_id': '${widget.roomId}',
                                  'message_id': '${state.messages[index].id}',
                                  'action': 'cheer'
                                };
                                context
                                    .read<ChatGroupCubit>()
                                    .sendMessage(payload);
                              },
                              onTapBool: () {
                                final payload = {
                                  'group_id': '${widget.roomId}',
                                  'message_id': '${state.messages[index].id}',
                                  'action': 'boo'
                                };
                                context
                                    .read<ChatGroupCubit>()
                                    .sendMessage(payload);
                              },
                              onReact: (messageId, reactOrAward) {
                                print(
                                    '#onTap react - send to remote award: $reactOrAward');
                              },
                              onReport: (messageId, reason) {
                                print(
                                    '#onTap report - send to remote reason: $reason');
                              },
                              onShare: (message) {
                                print(
                                    '#onTap share - do something to share: $message.id');
                              },
                              onPin: (messageToBePinned) {
                                print(
                                    '#onTap PIN - send to remote: $messageToBePinned.id');
                              },
                            );

                            if (lastDate != dateSummary) {
                              lastDate = dateSummary;
                              return Column(
                                children: [
                                  if (lastDate != '')
                                    Text(
                                      formatDate(dateSummary),
                                      style:
                                          TextStyle(fontSize: 12, height: 2.5),
                                    ),
                                  messageWidget,
                                ],
                              );
                            }

                            return messageWidget;
                          },
                        ),
                      ),
                    ),
                    //
                    //
                    Divider(height: 1, color: Colors.grey[300]),
                    //
                    //
                    messageInputSection(),
                    //
                    //
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
