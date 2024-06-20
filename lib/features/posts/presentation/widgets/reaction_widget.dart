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

      // Reflect the persisted states in counts
      if (isCheered) {
        cheersCount += 1;
      }
      if (isBooled) {
        boolsCount += 1;
      }
    });
  }

  Future<void> _saveReactionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.post.id}_isCheered', isCheered);
    await prefs.setBool('${widget.post.id}_isBooled', isBooled);
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
              setState(() {
                if (isCheered) {
                  // Decrement if it was already cheered
                  cheersCount -= 1;
                } else {
                  // Increment if it wasn't cheered
                  cheersCount += 1;
                }
                isCheered = !isCheered; // Toggle the state
              });
              // Save the reaction state
              _saveReactionState();

              // Trigger BLoC event for cheers
              BlocProvider.of<FeedbackBloc>(context).add(
                FeedbackButtonPressedEvent(
                    postId: widget.post.id, feedback: 'cheer', type: 'post'),
              );
            }
          },
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
        // Bools button
        InkWell(
          onTap: () {
            if (!isCheered) {
              setState(() {
                if (isBooled) {
                  // Decrement if it was already booled
                  boolsCount -= 1;
                } else {
                  // Increment if it wasn't booled
                  boolsCount += 1;
                }
                isBooled = !isBooled; // Toggle the state
              });
              // Save the reaction state
              _saveReactionState();

              // Trigger BLoC event for bools
              BlocProvider.of<FeedbackBloc>(context).add(
                FeedbackButtonPressedEvent(
                    postId: widget.post.id, feedback: 'boo', type: 'post'),
              );
            }
          },
          child: Row(
            children: [
              isBooled
                  ? Image.asset(
                      'assets/react2.png',
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      'assets/react6.png',
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
        // Other reaction buttons
        Row(
          children: [
            Image.asset(
              'assets/react3.png',
              width: 24,
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
        Row(
          children: [
            Image.asset(
              'assets/react7.png',
              width: 24,
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
        Row(
          children: [
            Image.asset(
              'assets/react4.png',
              width: 24,
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
        )
      ],
    );
  }
}
