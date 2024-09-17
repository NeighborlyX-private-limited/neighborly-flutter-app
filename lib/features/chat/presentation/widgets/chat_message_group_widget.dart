// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/menu_icon_widget.dart';
import '../../../../core/widgets/stacked_avatar_indicator_widget.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../data/model/chat_message_model.dart';

class ChatMessageGroupWidget extends StatefulWidget {
  final ChatMessageModel message;
  final bool? showIsReaded;
  final bool? showReply;
  final bool?
      isAdmin; // isAdmin inside the message flag admin message, but this one is a layer above
  final Function(ChatMessageModel) onTap;
  final Function(ChatMessageModel, String)? onReply;
  final Function(String, String) onReact;
  final Function(String, String) onReport;
  final Function(ChatMessageModel) onShare;
  final Function(ChatMessageModel) onPin;

  final Function(ChatMessageModel) onTapReply;
  final VoidCallback onTapCheer;
  final VoidCallback onTapBool;

  const ChatMessageGroupWidget({
    Key? key,
    required this.message,
    this.showIsReaded = false,
    this.showReply = true,
    this.isAdmin = false,
    required this.onTap,
    this.onReply,
    required this.onReact,
    required this.onReport,
    required this.onShare,
    required this.onPin,
    required this.onTapReply,
    required this.onTapCheer,
    required this.onTapBool,
  }) : super(key: key);

  @override
  State<ChatMessageGroupWidget> createState() => _ChatMessageGroupWidgetState();
}

class _ChatMessageGroupWidgetState extends State<ChatMessageGroupWidget> {
  OverlayEntry? _overlayEntry;
  bool showReplyInput = false;

  bool isCheered = false;
  bool isBooled = false;
  num repliesCount = 0;

  // State variables to track counts
  late num cheersCount;
  late num boolsCount;

  final messageEC = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  bool isCommentFilled = false;

  @override
  void initState() {
    super.initState();

    cheersCount = widget.message.cheers;
    boolsCount = widget.message.boos;
    repliesCount = widget.message.repliesCount;

    // Load persisted state
    _loadReactionState();
  }

  Future<void> _loadReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    setState(() {
      isCheered = box.get('${userID}_${widget.message.id}_isCheered',
          defaultValue: false);
      isBooled = box.get('${userID}_${widget.message.id}_isBooled',
          defaultValue: false);
    });
  }

  Future<void> _saveReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    await box.put('${userID}_${widget.message.id}_isCheered', isCheered);
    await box.put('${userID}_${widget.message.id}_isBooled', isBooled);
  }

  Future<void> _removeReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    await box.put('${userID}_${widget.message.id}_isCheered', false);
    await box.put('${userID}_${widget.message.id}_isBooled', false);
  }

  void _updateState(String reaction) {
    setState(() {
      if (reaction == 'cheer') {
        if (isCheered) {
          // User is un-cheering, decrement count
          if (cheersCount > 0) cheersCount -= 1;
          isCheered = false;
        } else {
          // User is cheering
          cheersCount += 1;
          isCheered = true;
          if (isBooled) {
            // Reverse boo if it was already booed
            if (boolsCount > 0) boolsCount -= 1;
            isBooled = false;
          }
        }
      } else if (reaction == 'boo') {
        if (isBooled) {
          // User is un-booing, decrement count
          if (boolsCount > 0) boolsCount -= 1;
          isBooled = false;
        } else {
          // User is booing
          boolsCount += 1;
          isBooled = true;
          if (isCheered) {
            // Reverse cheer if it was already cheered
            if (cheersCount > 0) cheersCount -= 1;
            isCheered = false;
          }
        }
      }
      // Save the new state
      _saveReactionState();
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageEC.dispose();
  }

  String formatTime(String lastMessageDate) {
    if (lastMessageDate == '') return lastMessageDate;
    DateTime parsedDate = DateTime.parse(lastMessageDate);

    // Format the date as "YYYY-MM-DD HH:mm:ss"
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat timeFormat = DateFormat('hh:mm a');
    DateTime dateTime = dateFormat.parse(formattedDate);
    return timeFormat.format(dateTime);
  }

  Widget isAdminBubble() {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: AppColors.lightBackgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          'Admin',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget reactionCircle(
      {required String assetUrl, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.lightBackgroundColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SvgPicture.asset(assetUrl),
        ),
      ),
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
                onChanged: (value) {},
                decoration: InputDecoration(
                    // suffixIcon: GestureDetector(
                    //   onTap: pickImage,
                    //   child: Icon(
                    //     Icons.photo_camera_back_outlined,
                    //     color: Colors.grey[600],
                    //   ),
                    // ),
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                // #send

                if (widget.onReply != null)
                  widget.onReply!(widget.message, messageEC.text);

                messageEC.clear();
                setState(() {
                  showReplyInput = false;
                });

                _removeOverlay();
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    print('Showing overlay');

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          setState(() {
            showReplyInput = false;
          });
          _removeOverlay();
        },
        child: Container(
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //
                //
                Container(
                  // height: 90,
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
                          avatarUrl: widget.message.author!.avatarUrl,
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
                              //
                              //
                              //
                              // author AREA
                              Row(
                                children: [
                                  Text(
                                    // message.date,
                                    widget.message.author?.name ?? '...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    formatTime(widget.message.date),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  if (widget.message.author?.isAdmin == true ||
                                      widget.message.isAdmin == true) ...[
                                    isAdminBubble(),
                                  ],
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
        onTap: () {
          setState(() {
                                    showReplyInput = false;
                                    // FocusScope.of(context).requestFocus(messageFocusNode);
                                  });
                                  _removeOverlay();
        }, child: Icon(Icons.close),),
                                    ),
                                  )
                                ],
                              ),
                              //
                              //
                              // message AREA
                              Container(
                                width:  MediaQuery.of(context).size.width,
                                child: widget.message.pictureUrl != '' && widget.message.text == ''
                                    ? Image.network(
                                        '${widget.message.pictureUrl}')
                                        //  : (widget.message.pictureAsset != null &&
                                        //     widget.message.pictureAsset?.path !=
                                        //         '')
                                        // ? Image.file(
                                        //     widget.message.pictureAsset!)
                                    : 
                                    Text(
                                            // message.date,
                                            widget.message.text,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                              ),
                              //
                              //
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //
                //
                // menu area
                Container(
                  height: showReplyInput
                      ? MediaQuery.of(context).size.height * 0.10
                      : MediaQuery.of(context).size.height * 0.40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //
                        //
                        if (showReplyInput == false) ...[
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
                          //
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                reactionCircle(
                                  assetUrl: 'assets/react5.svg',
                                  onTap: () {
                                    _updateState('cheer');
                                    _removeOverlay();
                                  },
                                ),
                                reactionCircle(
                                  assetUrl: 'assets/react6.svg',
                                  onTap: () {
                                    _updateState('boo');
                                    _removeOverlay();
                                  },
                                ),
                                reactionCircle(
                                  assetUrl: 'assets/Local_Legend.svg',
                                  onTap: () {
                                    // Function(String, String)?
                                    widget.onReact(
                                        widget.message.id, 'Local Legend');
                                    _removeOverlay();
                                  },
                                ),
                                reactionCircle(
                                  assetUrl: 'assets/Sunflower.svg',
                                  onTap: () {
                                    widget.onReact(
                                        widget.message.id, 'Sunflower');
                                    _removeOverlay();
                                  },
                                ),
                                reactionCircle(
                                  assetUrl: 'assets/Streetlight.svg',
                                  onTap: () {
                                    widget.onReact(
                                        widget.message.id, 'Streetlight');
                                    _removeOverlay();
                                  },
                                ),
                                reactionCircle(
                                  assetUrl: 'assets/Park_Bench.svg',
                                  onTap: () {
                                    widget.onReact(
                                        widget.message.id, 'Park Bench');
                                    _removeOverlay();
                                  },
                                ),
                                reactionCircle(
                                  assetUrl: 'assets/Map.svg',
                                  onTap: () {
                                    widget.onReact(widget.message.id, 'Map');
                                    _removeOverlay();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          //
                          //

                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: MenuIconItem(
                                title: 'See Replies',
                                svgPath: 'assets/menu_reply_list.svg',
                                iconSize: 25,
                                onTap: () {
                                  print('#replySee');

                                  widget.onTapReply(widget.message);
                                  _removeOverlay();
                                }),
                          ),
                          //
                          //
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0), // XXX
                            child: MenuIconItem(
                                title: 'Reply',
                                svgPath: 'assets/menu_reply.svg',
                                iconSize: 25,
                                onTap: () {
                                  print('#reply');

                                  setState(() {
                                    showReplyInput = true;
                                    // FocusScope.of(context).requestFocus(messageFocusNode);
                                  });
                                  _removeOverlay();

                                  setState(() {
                                    if (messageFocusNode.canRequestFocus) {
                                      messageFocusNode.requestFocus();
                                    }
                                    // FocusScope.of(context).requestFocus(messageFocusNode);
                                  });
                                  _showOverlay(context);
                                }),
                          ),
                          //
                          //

                          //
                          //
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: MenuIconItem(
                                title: 'Share',
                                svgPath: 'assets/menu_share.svg',
                                iconSize: 25,
                                onTap: () {
                                  // communityDetailCubit.toggleMute();
                                  widget.onShare(widget.message);

                                  setState(() {
                                    showReplyInput = false;
                                  });
                                  _removeOverlay();
                                }),
                          ),
                          //
                          //
                          if (widget.isAdmin == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MenuIconItem(
                                  title: 'Pinned Message',
                                  svgPath: 'assets/menu_pinned.svg',
                                  iconSize: 25,
                                  textColor: Colors.black,
                                  onTap: () {
                                    setState(() {
                                      showReplyInput = false;
                                    });
                                    _removeOverlay();
                                    widget.onPin(widget.message);
                                  }),
                            ),
                          //
                          //
                          if (widget.isAdmin == false)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MenuIconItem(
                                  title: 'Report',
                                  svgPath: 'assets/menu_report_core.svg',
                                  iconSize: 25,
                                  textColor: Colors.red,
                                  onTap: () {
                                    setState(() {
                                      showReplyInput = false;
                                    });
                                    _removeOverlay();
                                    reportReasonBottomSheet(context);
                                  }),
                            ),
                        ],
                        //
                        //
                        if (showReplyInput == true) ...[
                          messageInputSection(),
                          //
                          //
                        ],
                      ],
                    ),
                  ),
                ),
                //
                //
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
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

  Future<dynamic> reportReasonBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
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
                    ...kReportReasons
                        .map(
                          (e) => InkWell(
                            onTap: () async {
                              print('...on Select the report reason');
                              Navigator.of(context).pop();
                              widget.onReport(widget.message.id, e);
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
                        )
                        .toList(),
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

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget chatReactionLocalWidget() {
    // XXX
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Cheers button
        InkWell(
          onTap: () {
            _updateState('cheer');

            widget.onTapCheer();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 32,
            width: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: const BorderRadius.all(
                  Radius.circular(21),
                )),
            child: Center(
              child: Row(
                children: [
                  isCheered
                      ? SvgPicture.asset(
                          'assets/react5.svg',
                          width: 24,
                          height: 24,
                        )
                      : SvgPicture.asset(
                          'assets/react1.svg',
                          width: 24,
                          height: 24,
                        ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    cheersCount.toString(), // Use state variable for count
                    style: TextStyle(
                      color: isCheered ? Colors.red : Colors.grey[900],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        //
        //
        // Bools button
        InkWell(
          onTap: () {
            _updateState('boo');
            widget.onTapBool();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 32,
            width: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: const BorderRadius.all(
                  Radius.circular(21),
                )),
            child: Center(
              child: Row(
                children: [
                  isBooled
                      ? SvgPicture.asset(
                          'assets/react6.svg',
                          width: 24,
                          height: 24,
                        )
                      : SvgPicture.asset(
                          'assets/react2.svg',
                          width: 24,
                          height: 24,
                        ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    boolsCount.toString(), // Use state variable for count
                    style: TextStyle(
                      color: isBooled ? Colors.blue : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        //
        //
        if (widget.showReply == true)
          GestureDetector(
            onTap: () {
              widget.onTapReply(widget.message);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 32,
              // width: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(21),
                  )),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*
                    if (widget.message.repliesAvatas == null)
                      SvgPicture.asset(
                        'assets/react3.svg',
                        width: 20,
                        height: 24,
                      ),
                    //
                    //
                    if (widget.message.repliesAvatas != null)
                      StackedAvatarIndicator(
                        avatarUrls:
                            widget.message.repliesAvatas.map((e) => e).toList(),
                        showOnly: 4,
                        avatarSize: 20,
                        onTap: () {},
                      ),
                      */

                    //
                    //
                    const SizedBox(width: 5),
                    widget.message.repliesCount != null
                        ? Text(
                            '${widget.message.repliesCount} ${widget.message.repliesCount == 1 ? "reply" : "replies"}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ))
                        : const SizedBox(),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ),

        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 8),
        //   height: 32,
        //   width: 60,
        //   decoration: BoxDecoration(
        //       border: Border.all(color: Colors.grey[300]!),
        //       borderRadius: const BorderRadius.all(
        //         Radius.circular(21),
        //       )),
        //   child: Center(
        //     child: SvgPicture.asset(
        //       'assets/react4.svg',
        //       width: 20,
        //       height: 24,
        //     ),
        //   ),
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: UserAvatarStyledWidget(
              avatarUrl: widget.message.author!.avatarUrl,
              avatarBorderSize: 0,
              avatarSize: 22,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
            child: Container(
              // color: Colors.transparent,
              decoration: BoxDecoration(
                // color: message.isMine ? Colors.grey[100] : AppColors.lightBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //
                    //
                    //
                    // author AREA
                    Row(
                      children: [
                        Text(
                          // message.date,
                          widget.message.author?.name ?? '...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formatTime(widget.message.date),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (widget.message.author?.isAdmin == true ||
                            widget.message.isAdmin == true) ...[
                          isAdminBubble(),
                        ],
                      ],
                    ),
                    //
                    //
                    // message AREA
                    Container(
                      width:  MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () {
                          _showOverlay(context);
                        },
                        child: widget.message.pictureUrl != ''  && widget.message.text == ''
                            ? Image.network('${widget.message.pictureUrl}')
                            //  : (widget.message.pictureAsset != null &&
                            //         widget.message.pictureAsset?.path != '')
                            //     ? Image.file(widget.message.pictureAsset!)
                            : Text(
                                    // message.date,
                                    widget.message.text,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                      ),
                    ),
                    //
                    //
                    if ((widget.message.repliesCount +
                            widget.message.cheers +
                            widget.message.boos) >=
                        0) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: chatReactionLocalWidget(),

                        // ChatReactionWidget(
                        //   post: widget.message.toPost(),
                        //   repliesAvatar: widget.message.repliesAvatas,
                        //   onTapReply: () {
                        //     print('onTAP replay');
                        //   },
                        //   onTapCheer: () {
                        //     print('onTAP cheer');
                        //   },
                        //   onTapBool: () {
                        //     print('onTAP bool');
                        //   },
                        //   onTapMessage: (PostEntity) {
                        //     print('onTAP replay');
                        //   },
                        // ),
                      ),
                    ],
                    //
                    //
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
