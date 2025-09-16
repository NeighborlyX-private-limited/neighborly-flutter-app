import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/image_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/widgets/svg_icon.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/report_post_bloc/report_post_bloc.dart';
import 'option_card.dart';
import '../../../../core/entities/option_entity.dart';
import 'reaction_widget.dart';
import '../../../../l10n/app_localizations.dart';

class PollWidget extends StatefulWidget {
  final PostEntity post;
  final Function onDelete;

  const PollWidget({super.key, required this.post, required this.onDelete});

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  PostEntity? post;
  bool isselected = false;
  bool isrefresh = false;
  String? title;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    title = widget.post.title ?? '';
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      menuBottomSheet(context);
    }

    return InkWell(
      onTap: () async {
        await context
            .push('/post-detail/${widget.post.id}')
            // await context
            //     .push(
            //         '/post-detail/${widget.post.id}/${false}/${widget.post.userId}/0')
            .then((value) {
          widget.onDelete();
        });
        // print('calling');
      },
      child: Container(
        color: AppColors.whiteColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USER PROFILE, USER NAME, DATE AND TIME, MENU ICON ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (widget.post.userName.contains('[deleted]')) {
                      context.push('/deleted-user');
                    } else {
                      context.push('/userProfileScreen/${widget.post.userId}');
                    }
                  },
                  child: Row(
                    children: [
                      // USER PROFILE PIC
                      ClipOval(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: widget.post.proPic != null
                              ? CachedNetworkImage(
                                  imageUrl: widget.post.proPic!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircularSvgImage(
                                    assetPath: AppImages.defaultProfilePic,
                                    size: 40,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : widget.post.userName.contains('[deleted]')
                                  ? Image.asset(
                                      'assets/deleted_user.png',
                                    )
                                  : CircularSvgImage(
                                      assetPath: AppImages.defaultProfilePic,
                                      size: 40,
                                      color: AppColors.primaryColor,
                                    ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // USER NAME
                              widget.post.userName.contains('[deleted]')
                                  ? Text(
                                      AppLocalizations.of(context)!
                                          .neighborly_user,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    )
                                  : Text(
                                      widget.post.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                              const SizedBox(
                                width: 6,
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              // POLL TIME
                              Text(
                                formatTimeDifference(widget.post.createdAt),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          // CITY NAME
                          Text(
                            widget.post.city,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Icon(
                    Icons.more_horiz,
                    size: 30,
                    color: Colors.grey[500],
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Linkify(
                options: LinkifyOptions(
                  looseUrl: true,
                ),
                onOpen: (link) async {
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(Uri.parse(link.url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    throw "Could not launch ${link.url}";
                  }
                },
                text: title!,
                style: const TextStyle(fontSize: 16),
                linkStyle: const TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            widget.post.multimedia!.isNotEmpty
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            widget.post.multimedia != null &&
                    widget.post.multimedia!.isNotEmpty &&
                    widget.post.multimedia!.length > 1
                ? ImageSlider(
                    multimedia: widget.post.multimedia ?? [],
                  )
                : Container(),
            widget.post.multimedia != null &&
                    widget.post.multimedia!.isNotEmpty &&
                    widget.post.multimedia!.length == 1
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: widget.post.multimedia![0],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 125),
                            height: 300,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(10),
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            for (var option in post?.pollOptions ?? [])
              OptionCard(
                key: UniqueKey(),
                onSelectOptionCallback: onSelectOptionCallback,
                option: option,
                totalVotes: calculateTotalVotes(post?.pollOptions! ?? []),
                pollId: post?.id ?? 0,
                allowMultiSelect: widget.post.allowMultipleVotes ?? false,
                otherOptions: post?.pollOptions ?? [],
                alreadyselected: option.userVoted,
              ),
            const SizedBox(
              height: 20,
            ),
            ReactionWidget(
              post: widget.post,
            )
          ],
        ),
      ),
    );
  }

  // OPTION CARD
  onSelectOptionCallback(int optionid) {
    print('call 1');
    if (widget.post.allowMultipleVotes ?? false) {
      print('call 2');
      List<OptionEntity>? newOptions =
          List<OptionEntity>.from(post?.pollOptions ?? []);

      for (int i = 0; i < newOptions.length; i++) {
        newOptions[i] = newOptions[i].copyWith(
          userVoted: newOptions[i].optionId == optionid
              ? true
              : newOptions[i].userVoted,
          votes: newOptions[i].optionId == optionid
              ? (newOptions[i].votes ?? 0) + 1
              : newOptions[i].votes,
        );
      }

      setState(() {
        post = post?.copyWith(
          pollOptions: newOptions,
        );
        isrefresh = true;
      });

      Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          isrefresh = false;
        });
      });
    } else {
      print('call32');
      List<OptionEntity>? newOptions =
          List<OptionEntity>.from(post?.pollOptions ?? []);

      for (int i = 0; i < newOptions.length; i++) {
        newOptions[i] = newOptions[i].copyWith(
          userVoted: newOptions[i].optionId == optionid
              ? true
              : newOptions[i].userVoted,
          votes: newOptions[i].optionId == optionid
              ? (newOptions[i].votes ?? 0) + 1
              : newOptions[i].votes,
        );
      }

      setState(() {
        post = post?.copyWith(
          pollOptions: newOptions,
        );
        isrefresh = true;
      });

      Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          isrefresh = false;
        });
      });
    }
  }

  // MENU BOTTOM SHEET
  Future<dynamic> menuBottomSheet(BuildContext context) {
    void showReportReasonBottomSheet() {
      reportReasonBottomSheet(context);
    }

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        String? userId = ShardPrefHelper.getUserID();
        return SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  userId != widget.post.userId
                      // REPORT POST OPTION
                      ? ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Future.delayed(Duration(milliseconds: 200), () {
                              showReportReasonBottomSheet();
                            });
                          },
                          leading: Image.asset(
                            'assets/report_flag.png',
                            height: 24,
                            width: 24,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.report,
                            style: redOnboardingBody1Style,
                          ),
                          minTileHeight: 30,
                        )
                      // DELETE POST OPTION
                      : BlocConsumer<DeletePostBloc, DeletePostState>(
                          listener: (context, state) {
                            // DELETE POST SUCCESS STATE
                            if (state is DeletePostSuccessState) {
                              Navigator.of(context).pop();
                              widget.onDelete();
                              showSnackBar(
                                context: context,
                                message:
                                    AppLocalizations.of(context)!.post_deleted,
                              );
                            }
          
                            // DELETE POST FAILURE STATE
                            else if (state is DeletePostFailureState) {
                              Navigator.of(context).pop();
                              showSnackBar(
                                context: context,
                                message: state.error,
                              );
                            }
                          },
                          builder: (context, state) {
                            // DELETE POST LOADING STATE
                            if (state is DeletePostLoadingState) {
                              return CustomCircularIndicator();
                            }
                            return ListTile(
                              onTap: () {
                                context.read<DeletePostBloc>().add(
                                      DeletePostButtonPressedEvent(
                                        postId: widget.post.id,
                                        type: 'post',
                                      ),
                                    );
                              },
                              leading: Icon(
                                Icons.delete_outline_outlined,
                                color: AppColors.redColor,
                                size: 26,
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.delete_post,
                                style: redOnboardingBody1Style,
                              ),
                              minTileHeight: 30,
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // REPORT REASON BOTTOM SHEET
  Future<dynamic> reportReasonBottomSheet(BuildContext context) {
    void showReportConfirmationBottomSheet() {
      reportConfirmationBottomSheet(context);
    }

    // LIST OF REPORT REASON
    List<String> reportReasons = [
      AppLocalizations.of(context)!.inappropriate_content,
      AppLocalizations.of(context)!.spam,
      AppLocalizations.of(context)!.harassment_or_hate_speech,
      AppLocalizations.of(context)!.violence_or_dangerous_organizations,
      AppLocalizations.of(context)!.intellectual_property_violation,
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocConsumer<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            // REPORT POST SUCCESS STATE
            if (state is ReportPostSuccessState) {
              Navigator.of(context).pop();
              showReportConfirmationBottomSheet();
              widget.onDelete();
            }

            // REPORT POST FAILURE STATE
            else if (state is ReportPostFailureState) {
              Navigator.of(context).pop();
              showSnackBar(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            return SafeArea(child:  SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // REPORT POST LOADING STATE
                    state is ReportPostLoadingState
                        ? const CustomCircularIndicator()
                        : Center(
                      child: Text(
                        AppLocalizations.of(context)!.reason_to_report,
                        style: onboardingHeading2Style,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                          ReportButtonPressedEvent(
                            type: 'content',
                            postId: widget.post.id.toString(),
                            reason: reportReasons[0],
                          ),
                        );
                      },
                      title: Text(
                        reportReasons[0],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                          ReportButtonPressedEvent(
                            type: 'content',
                            postId: widget.post.id.toString(),
                            reason: reportReasons[1],
                          ),
                        );
                      },
                      title: Text(
                        reportReasons[1],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                      VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                          ReportButtonPressedEvent(
                            type: 'content',
                            postId: widget.post.id.toString(),
                            reason: reportReasons[2],
                          ),
                        );
                      },
                      title: Text(
                        reportReasons[2],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                      VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                          ReportButtonPressedEvent(
                            type: 'content',
                            postId: widget.post.id.toString(),
                            reason: reportReasons[3],
                          ),
                        );
                      },
                      title: Text(
                        reportReasons[3],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                      VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                          ReportButtonPressedEvent(
                            type: 'content',
                            postId: widget.post.id.toString(),
                            reason: reportReasons[4],
                          ),
                        );
                      },
                      title: Text(
                        reportReasons[4],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                      VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                  ],
                ),
              ),
            ));
          },
        );
      },
    );
  }

// REPORT POST CONFIRMATION BOTTOM SHEET
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          if (context.mounted) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        });
        return SafeArea(child: Container(
          color: AppColors.whiteColor,
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/report_confirmation.png'),
              Text(
                AppLocalizations.of(context)!.thanks_for_letting_us_know,
                style: onboardingHeading2Style,
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)!
                    .we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly,
                style: blackonboardingBody1Style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
      },
    );
  }
}
