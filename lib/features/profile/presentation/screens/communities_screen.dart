import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../posts/presentation/widgets/post_sheemer_widget.dart';
import '../bloc/get_my_groups_bloc/get_my_groups_bloc.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    String? userId = ShardPrefHelper.getUserID();
    var postState = context.read<GetMyGroupsBloc>().state;
    if (postState is! GetMyGroupsSuccessState) {
      BlocProvider.of<GetMyGroupsBloc>(context)
          .add(GetMyGroupsButtonPressedEvent(
        userId: userId,
      ));
      print('bloc called');
    }
  }

  Future<void> _onRefresh() async {
    String? userId = ShardPrefHelper.getUserID();
    BlocProvider.of<GetMyGroupsBloc>(context).add(GetMyGroupsButtonPressedEvent(
      userId: userId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios, size: 20),
          onTap: () => context.pop(),
        ),
        title: Text(
          'Joined communities',
          style: blackNormalTextStyle,
        ),
      ),
      body: RefreshIndicator(
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
                return const SizedBox();

                // return ListView.separated(
                //   itemCount: state.groups.length,
                //   itemBuilder: (context, index) {
                //     final post = state.groups[index];
                //     if (post.type == 'post') {
                //       // return PostWidget(post: post);
                //     } else if (post.type == 'poll') {
                //       return PollWidget(
                //         post: post,
                //       );
                //     }
                //     return const SizedBox();
                //   },
                //   separatorBuilder: (BuildContext context, int index) {
                //     return const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 5.0),
                //     );
                //   },
                // );
              } else if (state is GetMyGroupsFailureState) {
                if (state.error.contains('Invalid Token')) {
                  context.go('/loginScreen');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.error.contains('Internal server error')) {
                  return const Center(
                      child: Text(
                    'oops something went wrong',
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
      // Column(
      //   children: [
      //     Column(
      //         crossAxisAlignment: CrossAxisAlignment.start, children: []),
      //   ],
      // )
    ));
  }
}
