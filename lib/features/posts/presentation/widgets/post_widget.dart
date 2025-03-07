import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/image_slider.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/video_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/svg_icon.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/report_post_bloc/report_post_bloc.dart';
import 'reaction_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostWidget extends StatefulWidget {
  final PostEntity post;
  final Function onDelete;

  const PostWidget({
    super.key,
    required this.post,
    required this.onDelete,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String? title;
  String? content;

  // INIT STATE
  @override
  void initState() {
    print('pro pic: ${widget.post.proPic}');
    super.initState();
    title = widget.post.title ?? '';
    content = widget.post.content ?? '';
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    // SHOW MENU BOTTOM SHEET
    void showBottomSheet() {
      menuBottomSheet(context);
    }

    return GestureDetector(
      onTap: () {
        context
            .push('/post-detail/${widget.post.id}')
            // context
            //     .push(
            //         '/post-detail/${widget.post.id}/${true}/${widget.post.userId}/0')
            .then((value) {
          //   print('calling');

          //   print('calling');
          widget.onDelete();
        });
      },
      child: Container(
        color: AppColors.whiteColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USER PROFILE, USER NAME, POST DATE & TIME, MENU ICON ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
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
                          child: widget.post.proPic != null &&
                                  widget.post.proPic != ''
                              ? CachedNetworkImage(
                                  imageUrl: widget.post.proPic!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircularSvgImage(
                                    assetPath: AppImages.defaultProfilePic,
                                    size: 40,
                                  ),
                                )
                              : widget.post.userName.contains('[deleted]')
                                  ? Image.asset(
                                      'assets/deleted_user.png',
                                    )
                                  : CircularSvgImage(
                                      assetPath: AppImages.defaultProfilePic,
                                      size: 40,
                                    ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // USER NAME
                          Row(
                            children: [
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
                              // POST TIME
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
                GestureDetector(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Icon(
                    Icons.more_horiz,
                    size: 24,
                    color: Colors.grey[500],
                  ),
                )
              ],
            ),

            widget.post.title != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
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
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      linkStyle: const TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : Container(),

            widget.post.content != null
                ? Padding(
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
                      text: content!,
                      style: const TextStyle(fontSize: 16),
                      linkStyle: const TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : Container(),

            widget.post.multimedia != null &&
                    widget.post.multimedia!.isNotEmpty &&
                    widget.post.multimedia!.length > 1
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ImageSlider(
                      multimedia: widget.post.multimedia ?? [],
                    ),
                  )
                : Container(),
            widget.post.multimedia != null &&
                    widget.post.multimedia!.isNotEmpty &&
                    widget.post.multimedia!.length == 1 &&
                    widget.post.multimedia![0].contains('.mp4')
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: VideoDisplayWidget(
                      videoUrl: widget.post.multimedia![0],
                      thumbnailUrl: widget.post.thumbnail!,
                    ),
                  )
                : Container(),
            widget.post.multimedia != null &&
                    widget.post.multimedia!.isNotEmpty &&
                    widget.post.multimedia!.length == 1 &&
                    (!widget.post.multimedia![0].contains('.mp4'))
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: widget.post.multimedia![0],
                        fit: BoxFit.contain,
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
                              child: CustomCircularIndicator(),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline_outlined),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            // REACTION WIDGET
            ReactionWidget(
              post: widget.post,
            )
          ],
        ),
      ),
    );
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
        return SingleChildScrollView(
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
                              size: 24,
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
            return SingleChildScrollView(
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
            );
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
        return Container(
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
        );
      },
    );
  }
}
