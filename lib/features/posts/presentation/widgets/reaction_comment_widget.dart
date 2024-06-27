import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/feedback_bloc/feedback_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionCommentWidget extends StatefulWidget {
  final CommentEntity comment;

  const ReactionCommentWidget({
    super.key,
    required this.comment,
  });

  @override
  State<ReactionCommentWidget> createState() => _ReactionCommentWidgetState();
}

class _ReactionCommentWidgetState extends State<ReactionCommentWidget> {
  bool isCheered = false;
  bool isBooled = false;

  // State variables to track counts
  late num cheersCount;
  late num boolsCount;

  @override
  void initState() {
    super.initState();
    // Initialize state variables with initial counts
    cheersCount = widget.comment.cheers;
    boolsCount = widget.comment.bools;

    // Load persisted state
    _loadReactionState();
  }

  Future<void> _loadReactionState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load the state for the current post
      isCheered =
          prefs.getBool('${widget.comment.commentid}_isCheered') ?? false;
      isBooled = prefs.getBool('${widget.comment.commentid}_isBooled') ?? false;
    });
  }

  Future<void> _saveReactionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.comment.commentid}_isCheered', isCheered);
    await prefs.setBool('${widget.comment.commentid}_isBooled', isBooled);
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Cheers button
        InkWell(
          onTap: () {
            _updateState('cheer');

            // Trigger BLoC event for cheers
            BlocProvider.of<FeedbackBloc>(context).add(
              FeedbackButtonPressedEvent(
                  postId: widget.comment.commentid,
                  feedback: 'cheer',
                  type: 'comment'), // Corrected type to 'comment'
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 32,
            width: 56,
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
                          width: 20,
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
        // Bools button
        InkWell(
          onTap: () {
            _updateState('boo');

            // Trigger BLoC event for bools
            BlocProvider.of<FeedbackBloc>(context).add(
              FeedbackButtonPressedEvent(
                  postId: widget.comment.commentid,
                  feedback: 'boo',
                  type: 'comment'), // Corrected type to 'comment'
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 32,
            width: 56,
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
                          width: 20,
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
        // Additional reaction buttons
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 32,
          width: 56,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: const BorderRadius.all(
                Radius.circular(21),
              )),
          child: Center(
            child: Row(
              children: [
                Image.asset(
                  'assets/react7.png',
                  width: 20,
                  height: 24,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  '${widget.comment.awardType.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 32,
          width: 56,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: const BorderRadius.all(
                Radius.circular(21),
              )),
          child: Center(
            child: SvgPicture.asset(
              'assets/react4.svg',
              width: 20,
              height: 24,
            ),
          ),
        )
      ],
    );
  }
}
