import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:share_it/share_it.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/feedback_bloc/feedback_bloc.dart';
import '../bloc/give_award_bloc/give_award_bloc.dart';
import 'overlapping_images_widget.dart';
import '../../../profile/data/data_sources/profile_remote_data_source/profile_remote_data_source_impl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  num awardsCount = 0;
  bool isLocalLegendAwardAvailable = false;
  bool isParkBenchAwardAvailable = false;
  bool isSunflowerAwardAvailable = false;
  bool isStreetlightAwardAvailable = false;
  bool isMapAwardAvailable = false;
  int localLegendCount = 0;
  int parkBenchCount = 0;
  int sunflowerCount = 0;
  int streetlightCount = 0;
  int mapCount = 0;
  late ProfileRemoteDataSourceImpl profileRemoteDataSource;
  late num cheersCount;
  late num boolsCount;

  /// init state
  @override
  void initState() {
    super.initState();
    cheersCount = widget.post.cheers;
    boolsCount = widget.post.bools;
    awardsCount = widget.post.awardType.length;
    profileRemoteDataSource =
        ProfileRemoteDataSourceImpl(client: http.Client());

    _loadReactionState();
  }

  /// _loadReactionState method
  Future<void> _loadReactionState() async {
    getmyawards();
    setState(() {
      isCheered = widget.post.userFeedback == 'cheer';

      isBooled = widget.post.userFeedback == 'boo';
    });
  }

  ///getmyawards method
  getmyawards() async {
    List responseMessage = await profileRemoteDataSource.getMyAwards();
    bool localLegendAvailable = false;
    bool parkBenchAvailable = false;
    bool sunflowerAvailable = false;
    bool streetlightAvailable = false;
    bool mapAvailable = false;
    int localLegendCt = 0;
    int parkBenchCt = 0;
    int sunflowerCt = 0;
    int streetlightCt = 0;
    int mapCt = 0;

    if (responseMessage.isEmpty) {
      localLegendAvailable = false;
      parkBenchAvailable = false;
      sunflowerAvailable = false;
      streetlightAvailable = false;
      mapAvailable = false;
      localLegendCt = 0;
      parkBenchCt = 0;
      sunflowerCt = 0;
      streetlightCt = 0;
      mapCt = 0;
    } else {
      for (var award in responseMessage) {
        if (award['type'] == 'Local Legend') {
          if (award['count'] > 0) {
            localLegendAvailable = true;
            localLegendCt = award['count'];
          } else {
            localLegendCt = 0;
          }
        }

        if (award['type'] == 'Park Bench') {
          if (award['count'] > 0) {
            parkBenchAvailable = true;
            parkBenchCt = award['count'];
          } else {
            parkBenchCount = 0;
          }
        }
        if (award['type'] == 'Sunflower') {
          if (award['count'] > 0) {
            sunflowerAvailable = true;
            sunflowerCt = award['count'];
          } else {
            sunflowerCt = 0;
          }
        }
        if (award['type'] == 'Streetlight') {
          if (award['count'] > 0) {
            streetlightAvailable = true;
            streetlightCt = award['count'];
          } else {
            streetlightCt = 0;
          }
        }
        if (award['type'] == 'Map') {
          if (award['count'] > 0) {
            mapAvailable = true;
            mapCt = award['count'];
          } else {
            mapCt = 0;
          }
        }
      }
    }

    /// Update state once after the loop
    setState(() {
      isLocalLegendAwardAvailable = localLegendAvailable;
      isParkBenchAwardAvailable = parkBenchAvailable;
      isSunflowerAwardAvailable = sunflowerAvailable;
      isStreetlightAwardAvailable = streetlightAvailable;
      isMapAwardAvailable = mapAvailable;
      localLegendCount = localLegendCt;
      parkBenchCount = parkBenchCt;
      sunflowerCount = sunflowerCt;
      streetlightCount = streetlightCt;
      mapCount = mapCt;
    });
  }

  ///_saveReactionState in local
  Future<void> _saveReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    await box.put('${userID}_${widget.post.id}_isCheered', isCheered);
    await box.put('${userID}_${widget.post.id}_isBooled', isBooled);
  }

  ///_removeReactionState from  local
  Future<void> _removeReactionState() async {
    final userID = ShardPrefHelper.getUserID();
    final box = Hive.box('postReactions');
    await box.put('${userID}_${widget.post.id}_isCheered', false);
    await box.put('${userID}_${widget.post.id}_isBooled', false);
  }

  ///_updateState
  void _updateState(String reaction) {
    setState(() {
      if (reaction == 'cheer') {
        if (isCheered) {
          /// User is un-cheering, decrement count
          if (cheersCount > 0) cheersCount -= 1;
          isCheered = false;
        } else {
          /// User is cheering
          cheersCount += 1;
          isCheered = true;
          if (isBooled) {
            /// Reverse boo if it was already booed
            if (boolsCount > 0) boolsCount -= 1;
            isBooled = false;
          }
        }
      } else if (reaction == 'boo') {
        if (isBooled) {
          /// User is un-booing, decrement count
          if (boolsCount > 0) boolsCount -= 1;
          isBooled = false;
        } else {
          /// User is booing
          boolsCount += 1;
          isBooled = true;
          if (isCheered) {
            /// Reverse cheer if it was already cheered
            if (cheersCount > 0) cheersCount -= 1;
            isCheered = false;
          }
        }
      }

      /// Save the new state
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
        BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            ///Feedback Failure State
            if (state is FeedbackFailureState) {
              _removeReactionState();
            }
          },
          child: InkWell(
            onTap: () {
              _updateState('cheer');

              /// Trigger BLoC event for cheers
              BlocProvider.of<FeedbackBloc>(context).add(
                FeedbackButtonPressedEvent(
                  postId: widget.post.id,
                  feedback: 'cheer',
                  type: 'post',
                ),
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
                ),
              ),
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
                      cheersCount.toString(),
                      style: TextStyle(
                        color:
                            isCheered ? AppColors.redColor : Colors.grey[900],
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

        /// Bools button
        BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackFailureState) {
              _removeReactionState();
            }
          },
          child: InkWell(
            onTap: () {
              _updateState('boo');

              /// Trigger BLoC event for bools
              BlocProvider.of<FeedbackBloc>(context).add(
                FeedbackButtonPressedEvent(
                  postId: widget.post.id,
                  feedback: 'boo',
                  type: 'post',
                ),
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
                ),
              ),
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
                      boolsCount.toString(),
                      style: TextStyle(
                        color: isBooled
                            ? AppColors.primaryColor
                            : Colors.grey[600],
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

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 32,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: const BorderRadius.all(
              Radius.circular(21),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/react3.svg',
                  width: 20,
                  height: 24,
                ),
                const SizedBox(
                  width: 3,
                ),
                widget.post.commentCount != null
                    ? Text('${widget.post.commentCount}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                    : const SizedBox(),
              ],
            ),
          ),
        ),

        /// award button
        InkWell(
          onTap: () async {
            await getmyawards();
            showBottomSheet().then((value) {
              if (value != null) {
                setState(() {
                  awardsCount = value;
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
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.post.awardType.isEmpty
                      ? SvgPicture.asset(
                          'assets/react7.svg',
                          width: 20,
                          height: 25,
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

        InkWell(
          onTap: () {
            /// #share
            String link =
                'https://prod.neighborly.in/post-detail/${widget.post.id}/${widget.post.type == 'post' ? 'true' : 'false'}/${widget.post.userId}/0';
            ShareIt.text(content: link, androidSheetTitle: 'Share');
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
              child: SvgPicture.asset(
                'assets/react4.svg',
                width: 20,
                height: 24,
              ),
            ),
          ),
        )
      ],
    );
  }

  ///showBottomSheet
  Future<num?> showBottomSheet() {
    return showModalBottomSheet<num>(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<GiveAwardBloc, GiveAwardState>(
          listener: (context, state) {
            ///Give Award Failure State
            if (state is GiveAwardFailureState) {
              Navigator.pop(context, awardsCount);
              if (state.error.contains('Award not available')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .award_not_available_you_run_out_of_this_award),
                  ),
                );
              }
            }

            ///Give Award Success State
            else if (state is GiveAwardSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.award_given_successfully),
                ),
              );
              Navigator.pop(context, awardsCount + 1);
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
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
                        color: AppColors.lightGreyColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.award_this_post,
                        style: onboardingHeading2Style,
                      ),
                      InkWell(
                        onTap: () {
                          String karmaScore = ShardPrefHelper.getKarmaScore();
                          Navigator.pop(context);
                          context.push('/activityAndStatsScreen/$karmaScore');
                        },
                        child: Icon(Icons.info_outline_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: !isLocalLegendAwardAvailable
                        ? null
                        : () {
                            BlocProvider.of<GiveAwardBloc>(context).add(
                              GiveAwardButtonPressedEvent(
                                id: widget.post.id,
                                awardType: 'Local Legend',
                                type: 'post',
                              ),
                            );
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/Local_Legend.svg',
                              width: 84,
                              height: 84,
                              color: isLocalLegendAwardAvailable
                                  ? null
                                  : AppColors.greyColor.withOpacity(0.5),
                              colorBlendMode: BlendMode.modulate,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    localLegendCount.toString(),
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Local Legend',
                                style: GoogleFonts.roboto(
                                  color: isLocalLegendAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
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
                                  color: isLocalLegendAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: !isSunflowerAwardAvailable
                        ? null
                        : () {
                            BlocProvider.of<GiveAwardBloc>(context).add(
                              GiveAwardButtonPressedEvent(
                                id: widget.post.id,
                                awardType: 'Sunflower',
                                type: 'post',
                              ),
                            );
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/Sunflower.svg',
                              width: 84,
                              height: 84,
                              colorBlendMode: BlendMode.modulate,
                              color: isSunflowerAwardAvailable
                                  ? null
                                  : AppColors.greyColor.withOpacity(0.5),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    sunflowerCount.toString(),
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sunflower',
                                style: GoogleFonts.roboto(
                                  color: isSunflowerAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
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
                                  color: isSunflowerAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: !isStreetlightAwardAvailable
                        ? null
                        : () {
                            BlocProvider.of<GiveAwardBloc>(context).add(
                              GiveAwardButtonPressedEvent(
                                id: widget.post.id,
                                awardType: 'Streetlight',
                                type: 'post',
                              ),
                            );
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/Streetlight.svg',
                              width: 84,
                              height: 84,
                              colorBlendMode: BlendMode.modulate,
                              color: isStreetlightAwardAvailable
                                  ? null
                                  : AppColors.greyColor.withOpacity(0.5),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    streetlightCount.toString(),
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Streetlight',
                                style: GoogleFonts.roboto(
                                  color: isStreetlightAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
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
                                  color: isStreetlightAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: !isParkBenchAwardAvailable
                        ? null
                        : () {
                            BlocProvider.of<GiveAwardBloc>(context).add(
                              GiveAwardButtonPressedEvent(
                                id: widget.post.id,
                                awardType: 'Park Bench',
                                type: 'post',
                              ),
                            );
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/Park_Bench.svg',
                              width: 84,
                              height: 84,
                              colorBlendMode: BlendMode.modulate,
                              color: isParkBenchAwardAvailable
                                  ? null
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    parkBenchCount.toString(),
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Park Bench',
                                style: GoogleFonts.roboto(
                                  color: isParkBenchAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
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
                                  color: isParkBenchAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: !isMapAwardAvailable
                        ? null
                        : () {
                            BlocProvider.of<GiveAwardBloc>(context)
                                .add(GiveAwardButtonPressedEvent(
                              id: widget.post.id,
                              awardType: 'Map',
                              type: 'post',
                            ));
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/Map.svg',
                              width: 84,
                              height: 84,
                              colorBlendMode: BlendMode.modulate,
                              color: isMapAwardAvailable
                                  ? null
                                  : AppColors.greyColor.withOpacity(0.5),
                            ),
                            Positioned(
                              top: 0,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    mapCount.toString(),
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Map',
                                style: GoogleFonts.roboto(
                                  color: isMapAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
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
                                  color: isMapAwardAvailable
                                      ? AppColors.blackColor
                                      : AppColors.greyColor.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
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
