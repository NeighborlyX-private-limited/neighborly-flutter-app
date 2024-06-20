import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_comments_by_postId_bloc/get_comments_by_postId_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/comment_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    // var homeState = context.read<GetPostByIdBloc>().state;
    // if (homeState is! GetPostByIdSuccessState) {
    BlocProvider.of<GetPostByIdBloc>(context)
        .add(GetPostByIdButtonPressedEvent(postId: int.parse(widget.postId)));
    BlocProvider.of<GetCommentsByPostIdBloc>(context).add(
        GetCommentsByPostIdButtonPressedEvent(
            postId: int.parse(widget.postId)));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
              size: 15,
            ),
            onTap: () {
              context.pop();
            },
          ),
          centerTitle: true,
          title: Row(
            children: [
              const SizedBox(width: 100),
              Text(
                'Post',
                style: blackNormalTextStyle,
              ),
            ],
          ),
        ),
        body: BlocBuilder<GetPostByIdBloc, GetPostByIdState>(
            builder: (context, state) {
          if (state is GetPostByIdLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetPostByIdSuccessState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Column(
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
                                      child: state.post.proPic != null
                                          ? Image.network(
                                              state.post.proPic!,
                                              fit: BoxFit.contain,
                                            )
                                          : Image.asset(
                                              'assets/second_pro_pic.png',
                                              fit: BoxFit.contain,
                                            )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    state.post.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.more_horiz,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          state.post.title != null
                              ? Text(
                                  state.post.title!,
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    height: 1.3,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          state.post.content != null
                              ? Text(
                                  state.post.content!,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15,
                                    height: 1.3,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            convertDateString(state.post.createdAt),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 15,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReactionWidget(post: state.post),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<GetCommentsByPostIdBloc,
                              GetCommentsByPostIdState>(
                            builder: (context, state) {
                              if (state is GetcommentsByPostIdLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state
                                  is GetcommentsByPostIdSuccessState) {
                                if (state.comments.isEmpty) {
                                  return const Center(
                                    child: Text('No comments yet'),
                                  );
                                }

                                return ListView.separated(
                                  itemCount: state.comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = state.comments[index];
                                    return CommentWidget(comment: comment);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                    );
                                  },
                                );
                              } else if (state
                                  is GetcommentsByPostIdFailureState) {
                                return Center(
                                  child: Text(state.error),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is GetPostByIdFailureState) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}
