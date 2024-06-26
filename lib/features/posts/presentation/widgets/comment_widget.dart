import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/reply_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/fetch_comment_reply_bloc/fetch_comment_reply_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_comment_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reply_widget.dart';

class CommentWidget extends StatefulWidget {
  final CommentEntity comment;
  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _showReplies = false; // To track if replies are shown
  List<ReplyEntity> _replies = []; // To store fetched replies

  @override
  void initState() {
    super.initState();
  }

  void _fetchReplies() {
    setState(() {
      _showReplies = !_showReplies; // Toggle the showReplies state
    });
    if (_showReplies) {
      BlocProvider.of<FetchCommentReplyBloc>(context).add(
        FetchCommentReplyButtonPressedEvent(
            commentId: widget.comment.commentid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
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
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.035,
                    ),
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
                      const Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.3,
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
                      ? BlocListener<FetchCommentReplyBloc,
                          FetchCommentReplyState>(
                          listener: (context, state) {
                            if (state is FetchCommentReplySuccessState) {
                              setState(() {
                                _replies = state.reply;
                              });
                            } else if (state is FetchCommentReplyFailureState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            }
                          },
                          child: _replies.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                ),
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
}
