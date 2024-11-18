import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';

import '../../../../core/theme/text_style.dart';
import '../../../posts/presentation/widgets/poll_widget.dart';
import '../../../posts/presentation/widgets/post_sheemer_widget.dart';
import '../bloc/get_my_groups_bloc/get_my_groups_bloc.dart';

class GroupSection extends StatefulWidget {
  final String? userId;
  const GroupSection({super.key, this.userId});

  @override
  State<GroupSection> createState() => _GroupSectionState();
}

class _GroupSectionState extends State<GroupSection> {
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    var postState = context.read<GetMyGroupsBloc>().state;
    if (postState is! GetMyGroupsSuccessState) {
      BlocProvider.of<GetMyGroupsBloc>(context)
          .add(GetMyGroupsButtonPressedEvent(
        userId: widget.userId,
      ));
    }
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<GetMyGroupsBloc>(context).add(GetMyGroupsButtonPressedEvent(
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
          child: BlocBuilder<GetMyGroupsBloc, GetMyGroupsState>(
            builder: (context, state) {
              if (state is GetMyGroupsLoadingState) {
                return const PostSheemerWidget();
              } else if (state is GetMyGroupsSuccessState) {
                if (state.groups.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Communities joined yet.',
                          style: onboardingHeading2Style,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            context.go('/groups');
                          },
                          child: Text(
                            'Join your first community',
                            style: bluemediumTextStyleBlack,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    final post = state.groups[index];
                    if (post.type == 'post') {
                      // return PostWidget(post: post,onDelete: (){
                      //   print('this one is called');
                      //   //context.read<GetAllPostsBloc>().deletepost(post.id);
                      //   _onRefresh();
                      // });
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
              } else if (state is GetMyGroupsFailureState) {
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
                  return const Center(
                      child: Text(
                    'oops something went wrong',
                    style: TextStyle(color: AppColors.redColor),
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
