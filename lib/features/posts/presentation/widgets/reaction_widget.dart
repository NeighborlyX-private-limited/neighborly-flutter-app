import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';

import 'package:neighborly_flutter_app/features/posts/presentation/bloc/feedback_bloc/feedback_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionWidget extends StatefulWidget {
  final PostEntity post;

  const ReactionWidget({
    super.key,
    required this.post,
  });

  @override
  State<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  bool isCheered = false;
  bool isBooled = false;

  // State variables to track counts
  late num cheersCount;
  late num boolsCount;

  @override
  void initState() {
    super.initState();
    // Initialize state variables with initial counts
    cheersCount = widget.post.cheers;
    boolsCount = widget.post.bools;

    // Load persisted state
    _loadReactionState();
  }

  Future<void> _loadReactionState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load the state for the current post
      isCheered = prefs.getBool('${widget.post.id}_isCheered') ?? false;
      isBooled = prefs.getBool('${widget.post.id}_isBooled') ?? false;
    });
  }

  Future<void> _saveReactionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.post.id}_isCheered', isCheered);
    await prefs.setBool('${widget.post.id}_isBooled', isBooled);
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

    // Log values for debugging
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
            _updateState('cheer');

            // Trigger BLoC event for cheers
            BlocProvider.of<FeedbackBloc>(context).add(
              FeedbackButtonPressedEvent(
                  postId: widget.post.id, feedback: 'cheer', type: 'post'),
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
                      ? Image.asset(
                          'assets/react5.png',
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          'assets/react1.png',
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
        // Bools button
        InkWell(
          onTap: () {
            _updateState('boo');

            // Trigger BLoC event for bools
            BlocProvider.of<FeedbackBloc>(context).add(
              FeedbackButtonPressedEvent(
                  postId: widget.post.id, feedback: 'boo', type: 'post'),
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
                      ? Image.asset(
                          'assets/react6.png',
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          'assets/react2.png',
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
        // Other reaction buttons
        // Placeholder for additional reactions
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
                  'assets/react3.png',
                  width: 20,
                  height: 24,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  '${widget.post.commentCount}',
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
                  'assets/react7.png',
                  width: 20,
                  height: 24,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  '${widget.post.awardType.length}',
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
            child: Image.asset(
              'assets/react4.png',
              width: 20,
              height: 24,
            ),
          ),
        )
      ],
    );
  }
}
