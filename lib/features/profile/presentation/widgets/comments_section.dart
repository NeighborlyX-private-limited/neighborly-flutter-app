import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_my_comments_bloc/get_my_comments_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/post_with_comments_sheemer_widget.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/post_with_comments_widget.dart';

class CommentSection extends StatefulWidget {
  final String? userId;
  const CommentSection({super.key, this.userId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    var postState = context.read<GetMyCommentsBloc>().state;
    if (postState is! GetMyCommentsSuccessState) {
      BlocProvider.of<GetMyCommentsBloc>(context)
          .add(GetMyCommentsButtonPressedEvent(
        userId: widget.userId,
      ));
    }
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<GetMyCommentsBloc>(context)
        .add(GetMyCommentsButtonPressedEvent(
      userId: widget.userId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5FF),
      ),
      child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocBuilder<GetMyCommentsBloc, GetMyCommentsState>(
            builder: (context, state) {
              if (state is GetMyCommentsLoadingState) {
                return const PostWithCommentsShimmer();
              } else if (state is GetMyCommentsSuccessState) {
                if (state.post.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No comments yet.',
                          style: onboardingHeading2Style,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'When you comment on photos and polls, your comments will appear here.',
                          style: mediumTextStyleBlack,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: state.post.length,
                  itemBuilder: (context, index) {
                    final post = state.post[index];

                    return PostWithCommentsWidget(
                      post: post,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    );
                  },
                );
              } else if (state is GetMyCommentsFailureState) {
                if (state.error.contains('Invalid Token')) {
                  context.go('/loginScreengin');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.error.contains('Internal server error')) {
                  return const Center(
                      child: Text(
                    'Server Error',
                    style: TextStyle(color: Colors.red),
                  ));
                }
                return Center(child: Text(state.error));
              } else {
                return const Center(
                  child: Text('No data'),
                );
              }
            },
          )),
    );
  }
}
