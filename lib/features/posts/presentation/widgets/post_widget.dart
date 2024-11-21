import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/image_slider.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/video_widget.dart';

import '../../../../core/entities/post_enitity.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/report_post_bloc/report_post_bloc.dart';
import 'reaction_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    //print('video url HAI:${widget.post.multimedia![0]}');
    void showBottomSheet() {
      bottomSheet(context);
    }

    return InkWell(
      onTap: () {
        context.push(
            '/post-detail/${widget.post.id}/${true}/${widget.post.userId}/0');
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
                      context.push('/userProfileScreen/${widget.post.userId}');
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
                                      'Neighborly user',
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
              height: 12,
            ),
            widget.post.title != null
                ? Text(
                    widget.post.title!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      height: 1.3,
                    ),
                  )
                : Container(),
            widget.post.title != null
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            widget.post.content != null
                ? Text(
                    widget.post.content!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15,
                      height: 1.3,
                    ),
                  )
                : Container(),
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
                    widget.post.multimedia!.length == 1 &&
                    widget.post.multimedia![0].contains('.mp4')
                ? VideoDisplayWidget(
                    videoUrl: widget.post.multimedia![0],
                    thumbnailUrl: widget.post.thumbnail!,
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
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ))
                : Container(),
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
                        'Report',
                        style: redOnboardingBody1Style,
                      )
                    ],
                  ),
                )
              : BlocConsumer<DeletePostBloc, DeletePostState>(
                  listener: (context, state) {
                    if (state is DeletePostSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post Deleted'),
                        ),
                      );

                      context.pop(context);
                    } else if (state is DeletePostFailureState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is DeletePostLoadingState) {
                      return Center(
                        child: BouncingLogoIndicator(
                          logo: 'images/logo.svg',
                        ),
                      );
                      // return const Center(
                      //   child: CircularProgressIndicator(),
                      // );
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
                            'Delete Post',
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
                'Thanks for letting us know',
                style: onboardingHeading2Style,
              ),
              Text(
                textAlign: TextAlign.center,
                'We appreciate your help in keeping our community safe and respectful. Our team will review the content shortly.',
                style: blackonboardingBody1Style,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> reportReasonBottomSheet(BuildContext context) {
    void showReportConfirmationBottomSheet() {
      reportConfirmationBottomSheet(context);
    }

    List<String> reportReasons = [
      'Inappropriate content',
      'Spam',
      'Harassment or hate speech',
      'Violence or dangerous organizations',
      'Intellectual property violation',
    ];
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            if (state is ReportPostSuccessState) {
              Navigator.pop(context);
              Navigator.pop(context);
              showReportConfirmationBottomSheet();
            } else if (state is ReportPostFailureState) {
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
                        // ? Center(
                        //     child: BouncingLogoIndicator(
                        //       logo: 'images/logo.svg',
                        //     ),
                        //   )
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: Text(
                              'Reason to Report',
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
                                    reason: reportReasons[0]));
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
                                    reason: reportReasons[1]));
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
                                  reason: reportReasons[2])),
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
                                  reason: reportReasons[3])),
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
                                  reason: reportReasons[4])),
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
