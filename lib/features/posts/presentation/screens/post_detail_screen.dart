import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/posts/data/model/comments_model.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/reply_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_comments_by_postId_bloc/get_comments_by_postId_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/report_post_bloc/report_post_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/comment_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/option_card.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post_detail_sheemer.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final bool isPost;

  const PostDetailScreen(
      {super.key, required this.postId, required this.isPost});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late TextEditingController _commentController;
  bool isCommentFilled = false;
  final FocusNode _commentFocusNode = FocusNode();
  List<dynamic> comments = [];

  ReplyEntity?
      commentToReply; // Define commentToReply to track the comment being replied to

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _fetchPostAndComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  void _fetchPostAndComments() {
    final postId = int.parse(widget.postId);
    BlocProvider.of<GetPostByIdBloc>(context)
        .add(GetPostByIdButtonPressedEvent(postId: postId));
    BlocProvider.of<GetCommentsByPostIdBloc>(context)
        .add(GetCommentsByPostIdButtonPressedEvent(postId: postId));
  }

  Future<void> _onRefresh() async {
    final postId = int.parse(widget.postId);
    BlocProvider.of<GetPostByIdBloc>(context)
        .add(GetPostByIdButtonPressedEvent(postId: postId));
    BlocProvider.of<GetCommentsByPostIdBloc>(context)
        .add(GetCommentsByPostIdButtonPressedEvent(postId: postId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios, size: 15),
            onTap: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(widget.isPost ? 'Post' : 'Poll'),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocBuilder<GetPostByIdBloc, GetPostByIdState>(
            builder: (context, postState) {
              if (postState is GetPostByIdLoadingState) {
                return const PostDetailSheemer();
              } else if (postState is GetPostByIdSuccessState) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          widget.isPost
                              ? _buildPostDetails(postState.post)
                              : _buildPollWidget(postState),
                          const SizedBox(height: 20),
                          ReactionWidget(post: postState.post),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey[300], thickness: 1),
                          const SizedBox(height: 20),
                          BlocBuilder<GetCommentsByPostIdBloc,
                              GetCommentsByPostIdState>(
                            builder: (context, commentState) {
                              if (commentState
                                  is GetcommentsByPostIdSuccessState) {
                                comments = commentState.comments;
                                if (comments.isEmpty) {
                                  return const Center(
                                    child: Text('No comments yet'),
                                  );
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    return CommentWidget(
                                        commentFocusNode:
                                            _commentFocusNode, // Pass FocusNode
                                        comment: comments[index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                );
                              } else if (commentState
                                  is GetcommentsByPostIdFailureState) {
                                return Center(
                                  child: Text(commentState.error),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildCommentInputSection(),
                  ],
                );
              } else if (postState is GetPostByIdFailureState) {
                return Center(
                  child: Text(postState.error),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Column _buildPollWidget(GetPostByIdSuccessState postState) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: postState.post.proPic != null
                        ? Image.network(
                            postState.post.proPic!,
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
                          postState.post.userName,
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
                          formatTimeDifference(postState.post.createdAt),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      postState.post.city,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
                onTap: () {
                  showBottomSheet();
                },
                child:
                    Icon(Icons.more_horiz, size: 30, color: Colors.grey[500])),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '${postState.post.title}',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        for (var option in postState.post.pollOptions!)
          OptionCard(
            option: option,
            totalVotes: calculateTotalVotes(postState.post.pollOptions!),
            pollId: postState.post.id.toString(),
          ),
      ],
    );
  }

  Widget _buildCommentInputSection() {
    bool isReply = commentToReply != null; // Assuming you track this somewhere
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode:
                    _commentFocusNode, // Assign the FocusNode to TextField
                onChanged: (value) {
                  setState(() {
                    isCommentFilled = _commentController.text.isNotEmpty;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Add a comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            BlocConsumer<AddCommentBloc, AddCommentState>(
              listener: (context, state) {
                if (state is AddCommentFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return InkWell(
                  onTap: () {
                    if (isCommentFilled) {
                      final postId = int.parse(widget.postId);

                      if (isReply) {
                        // Handle sending reply to comment
                        BlocProvider.of<AddCommentBloc>(context).add(
                          AddCommentButtonPressedEvent(
                            commentId:
                                commentToReply!.id, // Use actual comment id
                            text: _commentController.text, postId: postId,
                          ),
                        );
                      } else {
                        String propic =
                            ShardPrefHelper.getUserProfilePicture()!;
                        String username = ShardPrefHelper.getUsername()!;
                        // Handle sending new comment
                        setState(() {
                          comments.insert(
                              0,
                              CommentModel(
                                userId: 'random',
                                userName: username, // Use actual user name
                                proPic: propic, // Use actual profile picture
                                text: _commentController.text,
                                createdAt: DateTime.now().toString(),
                                awardType: const [],
                                commentid: 0,
                                cheers: 0, bools: 0,
                              ));
                        });
                        BlocProvider.of<AddCommentBloc>(context).add(
                          AddCommentButtonPressedEvent(
                            postId: postId,
                            text: _commentController.text,
                          ),
                        );
                      }
                      _commentController.clear();
                      setState(() {
                        isCommentFilled = false;
                        commentToReply = null; // Reset reply state
                      });
                    }
                  },
                  child: Opacity(
                    opacity: isCommentFilled ? 1 : 0.3,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
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
          child: userId != widget.postId
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
              : InkWell(
                  onTap: () {
                    context.read<DeletePostBloc>().add(
                        DeletePostButtonPressedEvent(
                            postId: int.parse(widget.postId)));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post Deleted'),
                      ),
                    );
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
                                    postId: int.parse(widget.postId),
                                    reason: reportReasons[0]));
                          },
                          child: Text(
                            reportReasons[0],
                            style: blackonboardingBody1Style,
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
                                    postId: int.parse(widget.postId),
                                    reason: reportReasons[1]));
                          },
                          child: Text(
                            reportReasons[1],
                            style: blackonboardingBody1Style,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                  type: 'post',
                                  postId: int.parse(widget.postId),
                                  reason: reportReasons[2])),
                          child: Text(
                            reportReasons[2],
                            style: blackonboardingBody1Style,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                  type: 'post',
                                  postId: int.parse(widget.postId),
                                  reason: reportReasons[3])),
                          child: Text(
                            reportReasons[3],
                            style: blackonboardingBody1Style,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                  postId: int.parse(widget.postId),
                                  type: 'post',
                                  reason: reportReasons[4])),
                          child: Text(
                            reportReasons[4],
                            style: blackonboardingBody1Style,
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

  Widget _buildPostDetails(PostEntity post) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: post.proPic != null
                      ? Image.network(post.proPic!, fit: BoxFit.contain)
                      : const Image(
                          image: AssetImage('assets/second_pro_pic.png'),
                          fit: BoxFit.contain,
                        ),
                ),
                const SizedBox(width: 12),
                Text(post.userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
            InkWell(
                onTap: () {
                  showBottomSheet();
                },
                child:
                    Icon(Icons.more_horiz, size: 30, color: Colors.grey[500])),
          ],
        ),
        const SizedBox(height: 10),
        if (post.title != null)
          Text(
            post.title!,
            style: TextStyle(
              color: Colors.grey[900],
              fontWeight: FontWeight.w500,
              fontSize: 17,
              height: 1.3,
            ),
          ),
        const SizedBox(height: 10),
        if (post.content != null)
          Text(
            post.content!,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              height: 1.3,
            ),
          ),
        const SizedBox(height: 10),
        if (post.multimedia != null)
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                post.multimedia!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          convertDateString(post.createdAt),
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 15,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
