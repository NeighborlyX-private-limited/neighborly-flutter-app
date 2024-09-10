import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

import '../../../../core/entities/post_enitity.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/stacked_avatar_indicator_widget.dart';

class ChatReactionWidget extends StatefulWidget {
  final PostEntity post;
  final List<String>? repliesAvatar;
  final VoidCallback onTapReply;
  final VoidCallback onTapCheer;
  final VoidCallback onTapBool;
  final Function(PostEntity) onTapMessage;

  const ChatReactionWidget({
    Key? key,
    required this.post,
    this.repliesAvatar,
    required this.onTapReply,
    required this.onTapCheer,
    required this.onTapBool,
    required this.onTapMessage,
  }) : super(key: key);

  @override
  State<ChatReactionWidget> createState() => _ChatReactionWidgetState();
}

class _ChatReactionWidgetState extends State<ChatReactionWidget> {
  bool isCheered = false;
  bool isBooled = false;
  num repliesCount = 0;

  // State variables to track counts
  late num cheersCount;
  late num boolsCount;

  @override
  void initState() {
    super.initState();
    // Initialize state variables with initial counts
    cheersCount = widget.post.cheers;
    boolsCount = widget.post.bools;
    repliesCount = widget.post.awardType.length;

    // Load persisted state
    _loadReactionState();
  }

  Future<void> _loadReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    setState(() {
      isCheered =
          box.get('${userID}_${widget.post.id}_isCheered', defaultValue: false);
      isBooled =
          box.get('${userID}_${widget.post.id}_isBooled', defaultValue: false);
    });
  }

  Future<void> _saveReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    await box.put('${userID}_${widget.post.id}_isCheered', isCheered);
    await box.put('${userID}_${widget.post.id}_isBooled', isBooled);
  }

  Future<void> _removeReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    await box.put('${userID}_${widget.post.id}_isCheered', false);
    await box.put('${userID}_${widget.post.id}_isBooled', false);
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
  Widget build(BuildContext context) {
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
        GestureDetector(
          onTap: () {
            widget.onTapReply();
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
                  if (widget.repliesAvatar == null)
                    SvgPicture.asset(
                      'assets/react3.svg',
                      width: 20,
                      height: 24,
                    ),
                  //
                  //
                  if (widget.repliesAvatar != null)
                    StackedAvatarIndicator(
                      avatarUrls: widget.repliesAvatar!.map((e) => e).toList(),
                      showOnly: 4,
                      avatarSize: 20,
                      onTap: () {},
                    ),

                  //
                  //
                  const SizedBox(width: 5),
                  widget.post.commentCount != null
                      ? Text(
                          '${widget.post.commentCount} ${widget.post.commentCount == 1 ? "reply" : "replies"}',
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
}
