import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/reply_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/fetch_comment_reply_bloc/fetch_comment_reply_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_comment_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reply_widget.dart';

class CommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final FocusNode commentFocusNode; // Step 1: Define a FocusNode
  final Function(dynamic) onReplyTap; // Callback for reply tap

  const CommentWidget({
    super.key,
    required this.comment,
    required this.commentFocusNode,
    required this.onReplyTap,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _showReplies = false; // To track if replies are shown
  List<ReplyEntity> _replies = []; // To store fetched replies
  late FetchCommentReplyBloc _fetchCommentReplyBloc;

  @override
  void initState() {
    super.initState();
    _fetchCommentReplyBloc = BlocProvider.of<FetchCommentReplyBloc>(context);
  }

  void _fetchReplies() {
    setState(() {
      _showReplies = !_showReplies; // Toggle the showReplies state
    });
    if (_showReplies) {
      _fetchCommentReplyBloc.add(
        FetchCommentReplyButtonPressedEvent(
            commentId: widget.comment.commentid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Container(
                width: screenWidth * 0.1,
                height: screenWidth * 0.1,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: widget.comment.proPic != null
                    ? Image.network(
                        widget.comment.proPic!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/second_pro_pic.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.comment.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          showBottomSheet();
                        },
                        child: Icon(
                          Icons.more_horiz,
                          size: 30,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.comment.text,
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
                        timeAgo(widget.comment.createdAt),
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
                        onTap: () {
                          widget.onReplyTap(
                              widget.comment); // Set the comment to reply
                          widget.commentFocusNode
                              .requestFocus(); // Request focus for the comment text field
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
                  ReactionCommentWidget(
                    comment: widget.comment,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: _fetchReplies,
                    child: Text(
                      _showReplies ? 'Hide replies' : 'View replies',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _showReplies
                      ? BlocConsumer<FetchCommentReplyBloc,
                          FetchCommentReplyState>(
                          listener: (context, state) {
                            if (state is FetchCommentReplySuccessState &&
                                state.commentId == widget.comment.commentid) {
                              setState(() {
                                _replies = state.reply;
                              });
                            } else if (state is FetchCommentReplyFailureState &&
                                state.commentId == widget.comment.commentid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is FetchCommentReplyLoadingState &&
                                state.commentId == widget.comment.commentid) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return _replies.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _replies.length,
                                      itemBuilder: (context, index) {
                                        final reply = _replies[index];
                                        return ReplyWidget(
                                          reply: reply,
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Text('No reply yet'),
                                    );
                            }
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
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
          child: userId != widget.comment.userId
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
                          content: Text('Comment Deleted'),
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
                                postId: widget.comment.commentid,
                                type: 'comment'));
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
                            'Delete Comment',
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
                                    type: 'comment',
                                    postId: widget.comment.commentid,
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
                                    type: 'comment',
                                    postId: widget.comment.commentid,
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
                                  type: 'comment',
                                  postId: widget.comment.commentid,
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
                                  type: 'comment',
                                  postId: widget.comment.commentid,
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
                                  type: 'comment',
                                  postId: widget.comment.commentid,
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
}
