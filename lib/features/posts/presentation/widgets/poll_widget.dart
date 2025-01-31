import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/image_slider.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/report_post_bloc/report_post_bloc.dart';
import 'option_card.dart';
import '../../../../core/entities/option_entity.dart';
import 'reaction_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  /// init method
  @override
  void initState() {
    super.initState();
    uselocalpost();
  }

  ///use local post method
  uselocalpost() {
    setState(() {
      post = widget.post;
    });
  }

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    return InkWell(
      onTap: () {
        context.push(
            '/post-detail/${widget.post.id}/${false}/${widget.post.userId}/0');
      },
      child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (widget.post.userName.contains('[deleted]')) {
                        context.push('/deleted-user');
                      } else {
                        context
                            .push('/userProfileScreen/${widget.post.userId}');
                      }
                    },
                    child: Row(
                      children: [
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
                                        Icon(Icons.error),
                                  )
                                : widget.post.userName.contains('[deleted]')
                                    ? Image.asset(
                                        'assets/deleted_user.png',
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/second_pro_pic.png',
                                        fit: BoxFit.contain,
                                      ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                widget.post.userName.contains('[deleted]')
                                    ? Text(
                                        AppLocalizations.of(context)!
                                            .neighborly_user,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      )
                                    : Text(
                                        widget.post.userName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
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
                                Text(
                                  formatTimeDifference(widget.post.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.post.city,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                  fontSize: 14),
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
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.post.title}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.grey[800],
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
          )),
    );
  }

  /// onselect option call back funtion
  onSelectOptionCallback(int optionid) {
    if (widget.post.allowMultipleVotes ?? false) {
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

  /// bottom sheet method
  Future<dynamic> bottomSheet(BuildContext context) {
    void showReportReasonBottomSheet() {
      reportReasonBottomSheet(context);
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: AppColors.whiteColor,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: userId != widget.post.userId
              ? InkWell(
                  onTap: () {
                    showReportReasonBottomSheet();
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/report_flag.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.report,
                        style: redOnboardingBody1Style,
                      )
                    ],
                  ),
                )
              : BlocConsumer<DeletePostBloc, DeletePostState>(
                  listener: (context, state) {
                    ///Delete Post Success State
                    if (state is DeletePostSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.poll_deleted),
                        ),
                      );
                      context.pop(context);
                    }

                    ///Delete Post Failure State
                    else if (state is DeletePostFailureState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    /// Delete Post Loading State
                    if (state is DeletePostLoadingState) {
                      return Center(
                        child: BouncingLogoIndicator(
                          logo: 'images/logo.svg',
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        context.read<DeletePostBloc>().add(
                            DeletePostButtonPressedEvent(
                                postId: widget.post.id, type: 'post'));
                        widget.onDelete();
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete,
                            color: AppColors.redColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!.delete_poll,
                            style: redOnboardingBody1Style,
                          )
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  ///report Confirmation Bottom Sheet
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: AppColors.whiteColor,
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Image.asset('assets/report_confirmation.png'),
              Text(
                AppLocalizations.of(context)!.thanks_for_letting_us_know,
                style: onboardingHeading2Style,
              ),
              Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!
                    .we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly,
                style: blackonboardingBody1Style,
              ),
            ],
          ),
        );
      },
    );
  }

  ///report Reason Bottom Sheet
  Future<dynamic> reportReasonBottomSheet(BuildContext context) {
    void showReportConfirmationBottomSheet() {
      reportConfirmationBottomSheet(context);
    }

    List<String> reportReasons = [
      AppLocalizations.of(context)!.inappropriate_content,
      AppLocalizations.of(context)!.spam,
      AppLocalizations.of(context)!.harassment_or_hate_speech,
      AppLocalizations.of(context)!.violence_or_dangerous_organizations,
      AppLocalizations.of(context)!.intellectual_property_violation,
    ];

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            ///Report Post Success State
            if (state is ReportPostSuccessState) {
              Navigator.pop(context);
              Navigator.pop(context);
              showReportConfirmationBottomSheet();
            }

            ///Report Post Failure State
            else if (state is ReportPostFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                color: AppColors.whiteColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    state is ReportPostLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: Text(
                              AppLocalizations.of(context)!.reason_to_report,
                              style: onboardingHeading2Style,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            context.read<ReportPostBloc>().add(
                                  ReportButtonPressedEvent(
                                    type: 'content',
                                    postId: widget.post.id,
                                    reason: reportReasons[0],
                                  ),
                                );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                reportReasons[0],
                                style: blackonboardingBody1Style,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            context.read<ReportPostBloc>().add(
                                  ReportButtonPressedEvent(
                                    type: 'content',
                                    postId: widget.post.id,
                                    reason: reportReasons[1],
                                  ),
                                );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                reportReasons[1],
                                style: blackonboardingBody1Style,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => context.read<ReportPostBloc>().add(
                                ReportButtonPressedEvent(
                                  type: 'content',
                                  postId: widget.post.id,
                                  reason: reportReasons[2],
                                ),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                reportReasons[2],
                                style: blackonboardingBody1Style,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => context.read<ReportPostBloc>().add(
                                ReportButtonPressedEvent(
                                  type: 'content',
                                  postId: widget.post.id,
                                  reason: reportReasons[3],
                                ),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                reportReasons[3],
                                style: blackonboardingBody1Style,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => context.read<ReportPostBloc>().add(
                                ReportButtonPressedEvent(
                                  type: 'content',
                                  postId: widget.post.id,
                                  reason: reportReasons[4],
                                ),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                reportReasons[4],
                                style: blackonboardingBody1Style,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
