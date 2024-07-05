import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_widget.dart';
import 'package:neighborly_flutter_app/features/profile/domain/entities/post_with_comments_entity.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/profile_comment_reaction_widget.dart';

class PostWithCommentsWidget extends StatelessWidget {
  final PostWithCommentsEntity post;
  const PostWithCommentsWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    final screenWidth = MediaQuery.of(context).size.width;

    String userProPic = ShardPrefHelper.getUserProfilePicture()!;
    return InkWell(
      onTap: () {
        // context.push('/post-detail/${post.}/${true}/${post.userId}');
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      userProPic,
                      fit: BoxFit.contain,
                    )),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  post.userName,
                  style: mediumTextStyleBlack,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  'Commented on this',
                  style: mediumGreyTextStyleBlack,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    context.push('/userProfileScreen/${post.userId}');
                  },
                  child: Row(
                    children: [
                      Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: post.content.proPic != null
                              ? Image.network(
                                  post.content.proPic!,
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  'assets/second_pro_pic.png',
                                  fit: BoxFit.contain,
                                )),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
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
                                formatTimeDifference(post.createdAt),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            post.content.city,
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
            post.content.title != null
                ? Text(
                    post.content.title!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      height: 1.3,
                    ),
                  )
                : Container(),
            post.content.title != null
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            post.content.content != null
                ? Text(
                    post.content.content!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15,
                      height: 1.3,
                    ),
                  )
                : Container(),
            post.content.multimedia != null
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            post.content.multimedia != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          width: double.infinity,
                          height: 200,
                          post.content.multimedia!,
                          fit: BoxFit.cover,
                        )),
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            ReactionWidget(
              post: post.content,
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          userProPic,
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            post.commentText,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: screenWidth * 0.04,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                timeAgo(post.createdAt),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth * 0.035,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                // Use GestureDetector for tap handling
                                onTap: () {
                                  // Request focus for the comment text field
                                  // widget.commentFocusNode.requestFocus();
                                },
                                child: const Text(
                                  'Reply',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ProfileReactionCommentWidget(
                            postComment: post,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
          color: Colors.white,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: userId != post.userId
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        context.read<DeletePostBloc>().add(
                            DeletePostButtonPressedEvent(
                                postId: post.content.id, type: 'post'));
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete,
                            color: Colors.red,
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
          color: Colors.white,
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
                color: Colors.white,
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
                                    type: 'post',
                                    postId: post.content.id,
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
                                    type: 'post',
                                    postId: post.content.id,
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
                                  type: 'post',
                                  postId: post.content.id,
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
                                  type: 'post',
                                  postId: post.content.id,
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
                                  type: 'post',
                                  postId: post.content.id,
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
