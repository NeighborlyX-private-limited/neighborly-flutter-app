import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_all_posts_bloc/get_all_posts_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/poll_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post_sheemer_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/toggle_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHome = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome)); // Use isHome state
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome)); // Use isHome state
  }

  void handleToggle(bool value) {
    setState(() {
      isHome = value;
    });

    _fetchPosts(); // Fetch posts based on the new isHome value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              width: 30,
              height: 34,
            ),
            const SizedBox(width: 10),
            CustomToggleSwitch(
              imagePath1: 'assets/home.svg',
              imagePath2: 'assets/location.svg',
              onToggle: handleToggle, // Pass the callback function
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              'assets/alarm.svg',
              fit: BoxFit.contain,
              width: 30, // Adjusted to fit within the AppBar
              height: 30,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
          builder: (context, state) {
            if (state is GetAllPostsLoadingState) {
              return const PostSheemerWidget();
            } else if (state is GetAllPostsSuccessState) {
              final posts = state.post;
              return ListView.separated(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  if (post.type == 'post') {
                    return PostWidget(
                      post: post,
                    );
                  } else if (post.type == 'poll') {
                    return PollWidget(
                      post: post,
                    );
                  }
                  return const SizedBox();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  );
                },
              );
            } else if (state is GetAllPostsFailureState) {
              if (state.error.contains('Invalid Token')) {
                context.go('/loginScreen');
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
        ),
      ),
    );
  }
}
