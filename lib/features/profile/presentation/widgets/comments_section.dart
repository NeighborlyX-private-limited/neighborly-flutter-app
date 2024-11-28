import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import '../bloc/get_my_comments_bloc/get_my_comments_bloc.dart';
import 'post_with_comments_sheemer_widget.dart';
import 'post_with_comments_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        color: AppColors.lightBackgroundColor,
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
                      Text(AppLocalizations.of(context)!.no_comments),
                      Text(AppLocalizations.of(context)!
                          .that_is_an_opportunity_go_ahead_make_the_first_move),
                      // Text("No comments?"),
                      // Text(
                      //     'That’s an opportunity! Go ahead, make the first move.'),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor),
                        onPressed: () {
                          context.go('/home/Home');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.start_the_discussion,
                          // 'Start the Discussion',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                          ),
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
              return Center(
                child: Text(AppLocalizations.of(context)!.no_data),
                // child: Text('No data'),
              );
            }
          },
        ),
      ),
    );
  }
}
