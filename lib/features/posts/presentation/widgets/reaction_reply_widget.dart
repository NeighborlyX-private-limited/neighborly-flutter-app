import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/reply_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/feedback_bloc/feedback_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/give_award_bloc/give_award_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/overlapping_images_widget.dart';

class ReactionReplyWidget extends StatefulWidget {
  final ReplyEntity reply;

  const ReactionReplyWidget({
    super.key,
    required this.reply,
  });

  @override
  State<ReactionReplyWidget> createState() => _ReactionReplyWidgetState();
}

class _ReactionReplyWidgetState extends State<ReactionReplyWidget> {
  bool isCheered = false;
  bool isBooled = false;
  num awardsCount = 0;

  // State variables to track counts
  late num cheersCount;
  late num boolsCount;

  @override
  void initState() {
    super.initState();
    // Initialize state variables with initial counts
    cheersCount = widget.reply.cheers;
    boolsCount = widget.reply.bools;
    awardsCount = widget.reply.awardType.length;
    // Load persisted state
    _loadReactionState();
  }

  Future<void> _loadReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('replyReactions');
    setState(() {
      isCheered = box.get('${userID}_${widget.reply.id}_isCheered',
          defaultValue: false);
      isBooled =
          box.get('${userID}_${widget.reply.id}_isBooled', defaultValue: false);
    });
  }

  Future<void> _saveReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('replyReactions');
    await box.put('${userID}_${widget.reply.id}_isCheered', isCheered);
    await box.put('${userID}_${widget.reply.id}_isBooled', isBooled);
  }

  Future<void> _removeReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('replyReactions');
    await box.put('${userID}_${widget.reply.id}_isCheered', false);
    await box.put('${userID}_${widget.reply.id}_isBooled', false);
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
    String checkStringInList(String str) {
      switch (str) {
        case 'Local Legend':
          return 'assets/Local_Legend.svg';
        case 'Sunflower':
          return 'assets/Sunflower.svg';
        case 'Streetlight':
          return 'assets/Streetlight.svg';
        case 'Park Bench':
          return 'assets/Park_Bench.svg';
        case 'Map':
          return 'assets/Map.svg';
        default:
          return 'assets/react7.png';
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Cheers button
        BlocConsumer<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackFailureState) {
              _removeReactionState();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            } else if (state is FeedbackSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feedback submitted successfully!'),
                ),
              );
            }
          },
          builder: (context, state) {
            return InkWell(
              onTap: () {
                _updateState('cheer');

                // Trigger BLoC event for cheers
                BlocProvider.of<FeedbackBloc>(context).add(
                  FeedbackButtonPressedEvent(
                      postId: widget.reply.id,
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
            );
          },
        ),

        // Bools button
        BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackFailureState) {
              _removeReactionState();
            }
          },
          child: InkWell(
            onTap: () {
              _updateState('boo');

              // Trigger BLoC event for bools
              BlocProvider.of<FeedbackBloc>(context).add(
                FeedbackButtonPressedEvent(
                    postId: widget.reply.id,
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
        ),

        InkWell(
          onTap: () {
            showBottomSheet().then((value) {
              if (value != null) {
                setState(() {
                  awardsCount = value; // Update state with new awardsCount
                });
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            height: 32,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: const BorderRadius.all(
                  Radius.circular(21),
                )),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.reply.awardType.isEmpty
                      ? SvgPicture.asset(
                          'assets/react7.svg',
                          width: 20,
                          height: 25,
                        )
                      : widget.reply.awardType.length == 1
                          ? SvgPicture.asset(
                              checkStringInList(widget.reply.awardType[0]),
                              width: 20,
                              height: 24,
                            )
                          : widget.reply.awardType.length == 2
                              ? OverlappingImages(
                                  images: [
                                    checkStringInList(
                                        widget.reply.awardType[0]),
                                    checkStringInList(
                                        widget.reply.awardType[1]),
                                  ],
                                )
                              : OverlappingImages(
                                  images: [
                                    checkStringInList(
                                        widget.reply.awardType[0]),
                                    checkStringInList(
                                        widget.reply.awardType[1]),
                                    checkStringInList(
                                        widget.reply.awardType[2]),
                                  ],
                                ),
                  Text(
                    '$awardsCount',
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

  Future<num?> showBottomSheet() {
    return showModalBottomSheet<num>(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<GiveAwardBloc, GiveAwardState>(
          listener: (context, state) {
            if (state is GiveAwardFailureState) {
              Navigator.pop(context, awardsCount);
              if (state.error.contains('Award not available')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Award not available. You run out of this award.'),
                  ),
                );
              }
              // else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(state.error),
              //     ),
              //   );
              // }
            } else if (state is GiveAwardSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Award given successfully'),
                ),
              );
              Navigator.pop(context, awardsCount + 1);
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 800,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
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
                      'Award this post',
                      style: onboardingHeading2Style,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<GiveAwardBloc>(context).add(
                          GiveAwardButtonPressedEvent(
                              id: widget.reply.id,
                              awardType: 'Local Legend',
                              type: 'comment'));
                      // Navigator.pop(context, awardsCount + 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Local_Legend.svg',
                          width: 84,
                          height: 84,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          // Ensures the text wraps within the available space
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Local Legend',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Recognizing users who consistently contribute high-quality content.',
                                style: mediumGreyTextStyleBlack,
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Sunflower',
                        type: 'comment',
                      ));
                      // Navigator.pop(context, awardsCount + 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Sunflower.svg',
                          width: 84,
                          height: 84,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          // Ensures the text wraps within the available space
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sunflower',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For bringing positivity and cheerfulness to the community.',
                                style: mediumGreyTextStyleBlack,
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Streetlight',
                        type: 'comment',
                      ));
                      // Navigator.pop(context, awardsCount + 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Streetlight.svg',
                          width: 84,
                          height: 84,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          // Ensures the text wraps within the available space
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Streetlight',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For providing clear guidance and valuable insights.',
                                style: mediumGreyTextStyleBlack,
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Park Bench',
                        type: 'comment',
                      ));
                      // Navigator.pop(context, awardsCount + 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Park_Bench.svg',
                          width: 84,
                          height: 84,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          // Ensures the text wraps within the available space
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Park Bench',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For offering comforting and supportive posts.',
                                style: mediumGreyTextStyleBlack,
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Map',
                        type: 'comment',
                      ));
                      // Navigator.pop(context, awardsCount + 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Map.svg',
                          width: 84,
                          height: 84,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          // Ensures the text wraps within the available space
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Map',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For creating informative and detailed content.',
                                style: mediumGreyTextStyleBlack,
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
