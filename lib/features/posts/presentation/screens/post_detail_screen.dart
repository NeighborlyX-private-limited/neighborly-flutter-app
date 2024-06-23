import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_comments_by_postId_bloc/get_comments_by_postId_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/comment_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post_detail_sheemer.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late TextEditingController _commentController;
  bool isCommentFilled = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _fetchPostAndComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
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
          title: const Text('Post'),
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
                          _buildPostDetails(postState.post),
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
                                if (commentState.comments.isEmpty) {
                                  return const Center(
                                    child: Text('No comments yet'),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: commentState.comments.length,
                                  itemBuilder: (context, index) {
                                    return CommentWidget(
                                        comment: commentState.comments[index]);
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

  Widget _buildPostDetails(PostEntity post) {
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
            Icon(Icons.more_horiz, color: Colors.grey[500]),
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

  Widget _buildCommentInputSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
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
                    BlocProvider.of<AddCommentBloc>(context).add(
                      AddCommentButtonPressedEvent(
                        postId: postId,
                        text: _commentController.text,
                      ),
                    );
                    _commentController.clear();
                    setState(() {
                      isCommentFilled = false;
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
    );
  }
}
