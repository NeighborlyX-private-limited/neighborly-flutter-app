import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      // Load the state for the current comment
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
          if (cheersCount > 0) cheersCount -= 1; // Prevent negative count
          isCheered = false;
        } else {
          cheersCount += 1;
          isCheered = true;
          if (isBooled) {
            if (boolsCount > 0) boolsCount -= 1; // Prevent negative count
            isBooled = false;
          }
        }
      } else if (reaction == 'boo') {
        if (isBooled) {
          if (boolsCount > 0) boolsCount -= 1; // Prevent negative count
          isBooled = false;
        } else {
          boolsCount += 1;
          isBooled = true;
          if (isCheered) {
            if (cheersCount > 0) cheersCount -= 1; // Prevent negative count
            isCheered = false;
          }
        }
      }
      _saveReactionState(); // Save the reaction state
    });

    // Debug prints
    print('Cheers: $cheersCount, Boos: $boolsCount');
    print('Is Cheered: $isCheered, Is Booed: $isBooled');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Cheers button
        InkWell(
          onTap: () {
            if (!isBooled) {
              _updateState('cheer');

              // Trigger BLoC event for cheers
              BlocProvider.of<FeedbackBloc>(context).add(
                FeedbackButtonPressedEvent(
                    postId: widget.comment.commentid,
                    feedback: 'cheer',
                    type: 'comment'), // Corrected type to 'comment'
              );
            }
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
                      ? Image.asset(
                          'assets/react5.png',
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          'assets/react1.png',
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
            if (!isCheered) {
              _updateState('boo');

              // Trigger BLoC event for bools
              BlocProvider.of<FeedbackBloc>(context).add(
                FeedbackButtonPressedEvent(
                    postId: widget.comment.commentid,
                    feedback: 'boo',
                    type: 'comment'), // Corrected type to 'comment'
              );
            }
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
                      ? Image.asset(
                          'assets/react6.png',
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          'assets/react2.png',
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
                  '02',
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
            child: Row(
              children: [
                Image.asset(
                  'assets/react4.png',
                  width: 20,
                  height: 24,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  '02',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
