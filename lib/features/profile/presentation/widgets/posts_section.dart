import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import '../../../posts/presentation/widgets/poll_widget.dart';
import '../../../posts/presentation/widgets/post_sheemer_widget.dart';
import '../../../posts/presentation/widgets/post_widget.dart';
import '../bloc/get_my_posts_bloc/get_my_posts_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostSection extends StatefulWidget {
  final String? userId;
  const PostSection({super.key, this.userId});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    var postState = context.read<GetMyPostsBloc>().state;
    if (postState is! GetMyPostsSuccessState) {
      BlocProvider.of<GetMyPostsBloc>(context).add(GetMyPostsButtonPressedEvent(
        userId: widget.userId,
      ));
    }
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<GetMyPostsBloc>(context).add(GetMyPostsButtonPressedEvent(
      userId: widget.userId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightBackgroundColor,
      ),
      child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocBuilder<GetMyPostsBloc, GetMyPostsState>(
            builder: (context, state) {
              if (state is GetMyPostsLoadingState) {
                return const PostSheemerWidget();
              } else if (state is GetMyPostsSuccessState) {
                if (state.post.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/nothing.svg',
                                height: 150.0,
                                width: 150.0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Text(
                              //     "Time to be the hero this wall needs, start the"),
                              // Text('Conversation!'),
                              Text(AppLocalizations.of(context)!
                                  .time_to_be_the_hero_this_wall_needs_start_the),
                              //Text('Conversation!'),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor),
                                onPressed: () {
                                  context.push('/create');
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.create_a_post,
                                  // 'Create a Post',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: state.post.length,
                  itemBuilder: (context, index) {
                    final post = state.post[index];
                    if (post.type == 'post') {
                      return PostWidget(
                          post: post,
                          onDelete: () {
                            print('this one is called');
                            //context.read<GetAllPostsBloc>().deletepost(post.id);
                            _onRefresh();
                          });
                    } else if (post.type == 'poll') {
                      return PollWidget(
                          post: post,
                          onDelete: () {
                            print('this one is called');
                            //context.read<GetAllPostsBloc>().deletepost(post.id);
                            _onRefresh();
                          });
                    }
                    return const SizedBox();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    );
                  },
                );
              } else if (state is GetMyPostsFailureState) {
                if (state.error.contains('Invalid Token')) {
                  context.go('/loginScreen');
                  return Center(
                    child: BouncingLogoIndicator(
                      logo: 'images/logo.svg',
                    ),
                  );
                  // return const Center(
                  //   child: CircularProgressIndicator(),
                  // );
                }
                if (state.error.contains('Internal server error')) {
                  return Center(
                      child: Text(
                    AppLocalizations.of(context)!.oops_something_went_wrong,
                    // 'oops something went wrong',
                    style: TextStyle(color: AppColors.redColor),
                  ));
                }
                return Center(child: Text(state.error));
              } else {
                return const SizedBox();
              }
            },
          )),
    );
  }
}
