import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/fetch_comment_reply_bloc/fetch_comment_reply_bloc.dart';
import '../bloc/report_post_bloc/report_post_bloc.dart';
import 'reaction_comment_widget.dart';
import 'reply_widget.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class CommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final FocusNode commentFocusNode;
  final Function(dynamic) onReplyTap;
  final bool isPost;
  final Function onDelete;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.commentFocusNode,
    required this.onReplyTap,
    required this.isPost,
    required this.onDelete,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _showReplies = false;
  List<ReplyEntity> _replies = [];
  late FetchCommentReplyBloc _fetchCommentReplyBloc;
  bool isLoading = false;
  String commentText = '';

  /// update comment

  Future<bool> editComment({
    required String commentId,
    required String newText,
  }) async {
    print('hello text: $newText');
    isLoading = true;
    try {
      String? cookies = ShardPrefHelper.getCookie();
      String? accessToken = ShardPrefHelper.getAccessToken();

      if (cookies == null || cookies.isEmpty) {
        throw const ServerException(message: 'Oops, something went wrong.');
      }

      final url = Uri.parse('$kBaseUrl/posts/edit-comment');
      print('ur l $url');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      };

      final body = jsonEncode({
        'commentId': commentId,
        'text': newText,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("✅ Comment updated successfully: ${response.body}");
        return true;
      } else {
        print(
          "❌ Failed to update comment. "
          "Status: ${response.statusCode}, "
          "Body: ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("⚠️ Exception in editComment: $e");
      return false;
    } finally {
      isLoading = false; // ✅ Always stop loading
    }
  }

  Future<void> fetchComments({
    required String baseUrl,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/post/fetch-comments');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print("✅ Fetched comments: ${response.body}");
    } else {
      print("❌ Failed to fetch comments. Status: ${response.statusCode}");
    }
  }

  ///init method
  @override
  void initState() {
    super.initState();
    commentText = widget.comment.text;
    _fetchCommentReplyBloc = BlocProvider.of<FetchCommentReplyBloc>(context);
  }

  /// fetch replies
  void _fetchReplies() {
    setState(() {
      _showReplies = !_showReplies;
    });
    if (_showReplies) {
      _fetchCommentReplyBloc.add(
        FetchCommentReplyButtonPressedEvent(
          commentId: widget.comment.commentid,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    String? userId = ShardPrefHelper.getUserID();
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (widget.comment.userName.contains('[deleted]')) {
              context.push('/deleted-user');
            } else {
              context.push('/userProfileScreen/${widget.comment.userId}');
            }
          },
          child: Row(
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
                      : widget.comment.userName.contains('[deleted]')
                          ? Image.asset(
                              'assets/deleted_user.png',
                              fit: BoxFit.contain,
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
                          child: widget.comment.userName.contains('[deleted]')
                              ? Text(
                                  AppLocalizations.of(context)!.neighborly_user,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                )
                              : Text(
                                  widget.comment.userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: Row(
                            children: [
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
                              SizedBox(
                                width: 10,
                              ),
                              userId == widget.comment.userId
                                  ? InkWell(
                                      onTap: () async {
                                        await showCommentBottomSheet(
                                          context: context,
                                          comment: commentText,
                                          id: widget.comment.commentid
                                              .toString(),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.grey[500],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      commentText,
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
                            color: AppColors.greyColor,
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
                            widget.onReplyTap(widget.comment);
                            widget.commentFocusNode.requestFocus();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.reply,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
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
                      isPost: widget.isPost,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: _fetchReplies,
                      child: Text(
                        _showReplies
                            ? AppLocalizations.of(context)!.hide_replies
                            : AppLocalizations.of(context)!.view_replies,
                        style: const TextStyle(
                          color: AppColors.greyColor,
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
                              /// Fetch Comment Reply Success State
                              if (state is FetchCommentReplySuccessState &&
                                  state.commentId == widget.comment.commentid) {
                                setState(() {
                                  _replies = state.reply;
                                });
                              }

                              ///Fetch Comment Reply Failure State
                              else if (state is FetchCommentReplyFailureState &&
                                  state.commentId == widget.comment.commentid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
                                );
                              }
                            },
                            builder: (context, state) {
                              ///Fetch Comment Reply Loading State
                              if (state is FetchCommentReplyLoadingState &&
                                  state.commentId == widget.comment.commentid) {
                                return Center(
                                  child: BouncingLogoIndicator(
                                    logo: 'images/logo.svg',
                                  ),
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
                                    : Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .no_reply_yet),
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
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  /// bottom sheet
  Future<dynamic> bottomSheet(BuildContext context) {
    void showReportReasonBottomSheet() {
      reportReasonBottomSheet(context);
    }

    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: AppColors.whiteColor,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              userId != widget.comment.userId
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
                              content: Text(AppLocalizations.of(context)!
                                  .comment_deleted),
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
                        ///Delete Post Loading State
                        if (state is DeletePostLoadingState) {
                          return Center(
                            child: BouncingLogoIndicator(
                              logo: 'images/logo.svg',
                            ),
                          );
                        }
                        return InkWell(
                          onTap: () {
                            widget.onDelete();
                            context.read<DeletePostBloc>().add(
                                  DeletePostButtonPressedEvent(
                                    postId: widget.comment.commentid,
                                    type: 'comment',
                                  ),
                                );
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
                                AppLocalizations.of(context)!.delete_comment,
                                style: redOnboardingBody1Style,
                              )
                            ],
                          ),
                        );
                      },
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  /// comment edit
  Future<String?> showCommentBottomSheet({
    required BuildContext context,
    required String comment,
    required String id,
  }) {
    TextEditingController controller = TextEditingController(text: comment);

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // adjust for keyboard
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Edit Comment",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // just close
                      child: Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        bool success = await editComment(
                          commentId: id,
                          newText: controller.text.trim(),
                        );
                        print('successssssss": $success');
                        if (success) {
                          setState(() {
                            commentText = controller.text.trim();
                          });
                          Navigator.pop(
                            context,
                            controller.text,
                          ); // return updated comment
                        } else {
                          Navigator.pop(
                            context,
                            controller.text,
                          ); // return updated comment
                        }
                      },
                      child: Text("Submit"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// report reason bottom sheet
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
      useRootNavigator: true,
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
                                    type: 'comment',
                                    postId: widget.comment.commentid.toString(),
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
                                    type: 'comment',
                                    postId: widget.comment.commentid.toString(),
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
                                  type: 'comment',
                                  postId: widget.comment.commentid.toString(),
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
                                  type: 'comment',
                                  postId: widget.comment.commentid.toString(),
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
                                  type: 'comment',
                                  postId: widget.comment.commentid.toString(),
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

  /// report Confirmation Bottom Sheet
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      useRootNavigator: true,
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
}
