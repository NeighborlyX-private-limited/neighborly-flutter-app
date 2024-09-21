import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:share_it/share_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../domain/entities/reply_entity.dart';
import '../bloc/feedback_bloc/feedback_bloc.dart';
import '../bloc/give_award_bloc/give_award_bloc.dart';
import 'overlapping_images_widget.dart';
import '../../../profile/data/data_sources/profile_remote_data_source/profile_remote_data_source_impl.dart';
import 'package:http/http.dart' as http;
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
  late ProfileRemoteDataSourceImpl profileRemoteDataSource;
   bool isLocalLegendAwardAvailable = false;
  bool isParkBenchAwardAvailable = false;
  bool isSunflowerAwardAvailable = false;
  bool isStreetlightAwardAvailable = false;
  bool isMapAwardAvailable = false;

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
    // Initialize ProfileRemoteDataSourceImpl with an http.Client instance
    profileRemoteDataSource = ProfileRemoteDataSourceImpl(client: http.Client());
    // Load persisted state
    _loadReactionState();
  }

  Future<void> _loadReactionState() async {
    getmyawards();
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('replyReactions');
    setState(() {
      isCheered = widget.reply.userFeedback == 'cheer';
      isBooled =
          widget.reply.userFeedback == 'boo';
    });
  }

  getmyawards () async {
    List responseMessage = await profileRemoteDataSource.getMyAwards();
    if(responseMessage.length == 0){
       isLocalLegendAwardAvailable = false;
       isParkBenchAwardAvailable = false;
       isSunflowerAwardAvailable = false;
       isStreetlightAwardAvailable = false;
       isMapAwardAvailable = false;
    }else{
      for(int i=0;i<responseMessage.length; i++){
      if(responseMessage[i]['type'] == 'Local Legend' && responseMessage[i]['count'] > 0){
        setState((){
          isLocalLegendAwardAvailable = true;
        });
      }
      if(responseMessage[i]['type'] == 'Park Bench' && responseMessage[i]['count'] > 0){
        setState((){
          isParkBenchAwardAvailable = true;
        });
        
      }
      if(responseMessage[i]['type'] == 'Sunflower' && responseMessage[i]['count'] > 0){
        setState((){
          isSunflowerAwardAvailable = true;
        });
        
      }
      if(responseMessage[i]['type'] == 'Streetlight' && responseMessage[i]['count'] > 0){
        setState((){
          isStreetlightAwardAvailable = true;
        });
        
      }
      if(responseMessage[i]['type'] == 'Map' && responseMessage[i]['count'] > 0){
        setState((){
          isMapAwardAvailable = true;
        });
      }
    }
    }
    
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

        // InkWell(
        //   onTap: () {
        //     // #share
        //     ShareIt.text(
        //         content: 'Hey, take a look on this comment',
        //         androidSheetTitle: 'Cool Post');
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 8),
        //     height: 32,
        //     width: 56,
        //     decoration: BoxDecoration(
        //         border: Border.all(color: Colors.grey[300]!),
        //         borderRadius: const BorderRadius.all(
        //           Radius.circular(21),
        //         )),
        //     child: Center(
        //       child: SvgPicture.asset(
        //         'assets/react4.svg',
        //         width: 20,
        //         height: 24,
        //       ),
        //     ),
        //   ),
        // )
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
                  Container(
                    decoration: BoxDecoration(
                  ),
                  child:InkWell(
                    onTap: !isLocalLegendAwardAvailable ? null : () {
                      BlocProvider.of<GiveAwardBloc>(context).add(
                        GiveAwardButtonPressedEvent(
                          id: widget.reply.id,
                          awardType: 'Local Legend',
                          type: 'post',
                        ),
                      );
                    } ,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Local_Legend.svg',
                          width: 84,
                          height: 84,
                          color: isLocalLegendAwardAvailable ? null :  Colors.grey.withOpacity(0.5), // Apply grey tint when disabled
                          colorBlendMode: BlendMode.modulate,
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
                                style: GoogleFonts.roboto(
                                color: isLocalLegendAwardAvailable ? Color(0xff3D3D3D) :  Colors.grey.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Recognizing users who consistently contribute high-quality content.',
                                style: GoogleFonts.roboto(
                                color: isLocalLegendAwardAvailable ? Color(0xff2E2E2E) :  Colors.grey.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  InkWell(
                    onTap: !isSunflowerAwardAvailable? null :() {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Sunflower',
                        type: 'post',
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
                          colorBlendMode: BlendMode.modulate,
                          color: isSunflowerAwardAvailable ? null :  Colors.grey.withOpacity(0.5),
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
                                style: GoogleFonts.roboto(
                                color: isSunflowerAwardAvailable ? Color(0xff3D3D3D) :  Colors.grey.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For bringing positivity and cheerfulness to the community.',
                                style: GoogleFonts.roboto(
                                color: isSunflowerAwardAvailable ? Color(0xff2E2E2E) :  Colors.grey.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: !isStreetlightAwardAvailable ? null : () {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Streetlight',
                        type: 'post',
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
                          colorBlendMode: BlendMode.modulate,
                          color: isStreetlightAwardAvailable ? null :  Colors.grey.withOpacity(0.5),
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
                                style: GoogleFonts.roboto(
                                color: isStreetlightAwardAvailable ? Color(0xff3D3D3D) :  Colors.grey.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For providing clear guidance and valuable insights.',
                                style: GoogleFonts.roboto(
                                color: isStreetlightAwardAvailable ? Color(0xff2E2E2E) :  Colors.grey.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: !isParkBenchAwardAvailable ? null : () {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Park Bench',
                        type: 'post',
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
                          colorBlendMode: BlendMode.modulate,
                          color: isParkBenchAwardAvailable ? null :  Colors.grey.withOpacity(0.5),
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
                                style: GoogleFonts.roboto(
                                color: isParkBenchAwardAvailable ? Color(0xff3D3D3D) :  Colors.grey.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For offering comforting and supportive posts.',
                                style: GoogleFonts.roboto(
                                color: isParkBenchAwardAvailable ? Color(0xff2E2E2E) :  Colors.grey.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                                softWrap: true, // Enables text wrapping
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: !isMapAwardAvailable ? null : () {
                      BlocProvider.of<GiveAwardBloc>(context)
                          .add(GiveAwardButtonPressedEvent(
                        id: widget.reply.id,
                        awardType: 'Map',
                        type: 'post',
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
                          colorBlendMode: BlendMode.modulate,
                          color: isMapAwardAvailable ? null :  Colors.grey.withOpacity(0.5),
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
                                style: GoogleFonts.roboto(
                                color: isMapAwardAvailable ? Color(0xff3D3D3D) :  Colors.grey.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'For creating informative and detailed content.',
                                style: GoogleFonts.roboto(
                                color: isMapAwardAvailable ? Color(0xff2E2E2E) :  Colors.grey.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
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
