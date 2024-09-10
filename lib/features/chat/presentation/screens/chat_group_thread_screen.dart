import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/chat_room_model.dart';
import '../bloc/chat_group_cubit.dart';
import '../widgets/chat_message_group_widget.dart';
import '../widgets/chat_messages_group_sheemer.dart';

class ChatGroupThreadScreen extends StatefulWidget {
  final String messageId;
  final ChatRoomModel room;
  final ChatMessageModel message;

  const ChatGroupThreadScreen({
    Key? key,
    required this.messageId,
    required this.room,
    required this.message,
  }) : super(key: key);

  @override
  State<ChatGroupThreadScreen> createState() => _ChatGroupThreadScreenState();
}

class _ChatGroupThreadScreenState extends State<ChatGroupThreadScreen> {
  late var chatGroupCubit;

  final messageEC = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  bool isCommentFilled = false;
  File? fileToUpload;

  @override
  void initState() {
    super.initState();

    chatGroupCubit = BlocProvider.of<ChatGroupCubit>(context);
    // chatGroupCubit.init(widget.roomId); // widget.roomId;
    print('... THREAD INIT');
    print('... room=${widget.room}');
    print('... message=${widget.message}');
  }

  @override
  void dispose() {
    super.dispose();
    messageEC.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
            Navigator.pop(context);
          },
        ),
        const SizedBox(
          width: 10,
        ),
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
                      'Thread',
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
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.room.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black45,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
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
                chatGroupCubit.sendMessage(
                    message: messageEC.text, image: fileToUpload);

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
        },
        builder: (context, state) {
          //
          //
          int lineCount = 1;
          String lastDate = '';
          return BlocBuilder<ChatGroupCubit, ChatGroupState>(
            bloc: chatGroupCubit,
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Container(
                    color: Colors.white, child: ChatMessagesGroupSheemer());
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
                    // Fixed content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChatMessageGroupWidget(
                        message: widget.message,
                        showReply: false,
                        showIsReaded: false,
                        onTap: (msgSelected) {
                          print('....selected=${msgSelected}');
                          print('lineCount=${lineCount}');
                        },
                        onReply: (msgIdToSendReply, message) {
                          print('#send reply');
                          print('msgIdToSendReply=$msgIdToSendReply ');
                          print('message=$message ');
                        },
                        onTapReply: (ChatMessageModel) {
                          print('#onTag reply');
                        },
                        onTapCheer: () {
                          print('#onTap cheer - send to remote');
                        },
                        onTapBool: () {
                          print('#onTap bool - send to remote');
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(color: Colors.grey, height: 2),
                    ),
                    //
                    //
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          reverse: true, // Inverter a ordem da lista
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            var msg = state.messages[index];

                            // var dateSummary = state.messages[index].date.split(" ")[0] ?? state.messages[index].date.split("T")[0];

                            var dateSummary =
                                onlyDate(state.messages[index].date);
                            print('..FODA dateSummary=$dateSummary');

                            var messageWidget = ChatMessageGroupWidget(
                              message: msg,
                              showReply: false,
                              showIsReaded:
                                  (lineCount == state.messages.length) &&
                                      msg.isMine,
                              onTap: (msgSelected) {
                                print('....selected=${msgSelected}');
                                print('lineCount=${lineCount}');
                              },
                              onReply: (msgIdToSendReply, message) {
                                print('#send reply');
                                print('msgIdToSendReply=$msgIdToSendReply ');
                                print('message=$message ');
                              },
                              onTapReply: (ChatMessageModel) {
                                print('#onTag reply');
                              },
                              onTapCheer: () {
                                print('#onTap cheer - send to remote');
                              },
                              onTapBool: () {
                                print('#onTap bool - send to remote');
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
