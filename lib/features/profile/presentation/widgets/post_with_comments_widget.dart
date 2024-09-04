import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../posts/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import '../../../posts/presentation/widgets/reaction_widget.dart';
import '../../domain/entities/post_with_comments_entity.dart';
import 'profile_comment_reaction_widget.dart';

class PostWithCommentsWidget extends StatefulWidget {
  final PostWithCommentsEntity post;

  const PostWithCommentsWidget({
    super.key,
    required this.post,
  });

  @override
  State<PostWithCommentsWidget> createState() => _PostWithCommentsWidgetState();
}

class _PostWithCommentsWidgetState extends State<PostWithCommentsWidget> {
  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    void showBottomSheet(bool isComment) {
      bottomSheet(context, isComment);
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
            InkWell(
              onTap: () {
                context.push('/userProfileScreen/${widget.post.userId}');
              },
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          userProPic,
                          fit: BoxFit.contain,
                        )),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.post.userName,
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
            ),
            const Divider(),
            InkWell(
              onTap: () {
                context.push(
                    '/post-detail/${widget.post.content.id}/${true}/${widget.post.userId}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .push('/userProfileScreen/${widget.post.userId}');
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
                                  child: widget.post.content.proPic != null
                                      ? Image.network(
                                          widget.post.content.proPic!,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(
                                          'assets/second_pro_pic.png',
                                          fit: BoxFit.contain,
                                        )),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
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
                                      formatTimeDifference(
                                          widget.post.createdAt),
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.post.content.city,
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
                          showBottomSheet(false);
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
                  widget.post.content.title != null
                      ? Text(
                          widget.post.content.title!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            height: 1.3,
                          ),
                        )
                      : Container(),
                  widget.post.content.title != null
                      ? const SizedBox(
                          height: 10,
                        )
                      : Container(),
                  widget.post.content.content != null
                      ? Text(
                          widget.post.content.content!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15,
                            height: 1.3,
                          ),
                        )
                      : Container(),
                  widget.post.content.multimedia != null
                      ? const SizedBox(
                          height: 10,
                        )
                      : Container(),
                  widget.post.content.multimedia != null
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                width: double.infinity,
                                height: 200,
                                widget.post.content.multimedia!,
                                fit: BoxFit.cover,
                              )),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  ReactionWidget(
                    post: widget.post.content,
                  ),
                  !isDeleted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
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
                                    child: widget.post.content.proPic != null
                                        ? Image.network(
                                            userProPic,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.post.userName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth * 0.035,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              showBottomSheet(true);
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
                                        widget.post.commentText,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            timeAgo(widget.post.createdAt),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenWidth * 0.035,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ProfileReactionCommentWidget(
                                        postComment: widget.post,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> bottomSheet(BuildContext context, bool isComment) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BlocConsumer<DeletePostBloc, DeletePostState>(
            listener: (context, state) {
              if (state is DeletePostSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(isComment ? 'Comment Deleted' : 'Post Deleted'),
                  ),
                );
                context.pop(context);
                setState(() {
                  isDeleted = true;
                });
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
                          postId: isComment
                              ? widget.post.commentId
                              : widget.post.content.id,
                          type: isComment ? 'comment' : 'post'));
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
                      isComment ? 'Delete Comment' : 'Delete Post',
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
}
