import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/feedback_bloc/feedback_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/give_award_bloc/give_award_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/overlapping_images_widget.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      bottomSheet(context);
    }

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
        // Other reaction buttons
        // Placeholder for additional reactions
        Container(
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
                SvgPicture.asset(
                  'assets/react3.svg',
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
        InkWell(
          onTap: () {
            showBottomSheet();
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
                  widget.post.awardType.isEmpty
                      ? Image.asset(
                          'assets/react7.png',
                          width: 20,
                          height: 24,
                        )
                      : widget.post.awardType.length == 1
                          ? SvgPicture.asset(
                              checkStringInList(widget.post.awardType[0]),
                              width: 20,
                              height: 24,
                            )
                          : widget.post.awardType.length == 2
                              ? OverlappingImages(
                                  images: [
                                    checkStringInList(widget.post.awardType[0]),
                                    checkStringInList(widget.post.awardType[1]),
                                  ],
                                )
                              : OverlappingImages(
                                  images: [
                                    checkStringInList(widget.post.awardType[0]),
                                    checkStringInList(widget.post.awardType[1]),
                                    checkStringInList(widget.post.awardType[2]),
                                  ],
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
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 32,
          width: 60,
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

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
                            id: widget.post.id,
                            awardType: 'Local Legend',
                            type: 'post'));
                    Navigator.pop(context);
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
                      id: widget.post.id,
                      awardType: 'Sunflower',
                      type: 'post',
                    ));
                    Navigator.pop(context);
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
                      id: widget.post.id,
                      awardType: 'Streetlight',
                      type: 'post',
                    ));
                    Navigator.pop(context);
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
                      id: widget.post.id,
                      awardType: 'Park Bench',
                      type: 'post',
                    ));
                    Navigator.pop(context);
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
                      id: widget.post.id,
                      awardType: 'Map',
                      type: 'post',
                    ));
                    Navigator.pop(context);
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
        );
      },
    );
  }
}
