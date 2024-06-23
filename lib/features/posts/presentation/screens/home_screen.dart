import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_all_posts_bloc/get_all_posts_bloc.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post_sheemer_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    var homeState = context.read<GetAllPostsBloc>().state;
    if (homeState is! GetAllPostsSuccessState) {
      BlocProvider.of<GetAllPostsBloc>(context)
          .add(GetAllPostsButtonPressedEvent());
    }
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset(
            height: 100,
            width: 90,
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/alarm.png',
              fit: BoxFit.contain,
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
              return ListView.separated(
                itemCount: state.post.length,
                itemBuilder: (context, index) {
                  final post = state.post[index];
                  return PostWidget(post: post);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  );
                },
              );
            } else if (state is GetAllPostsFailureState) {
              if (state.error.contains('Invalid Token')) {
                context.go('/loginScreengin');
                return const Center(
                  child: CircularProgressIndicator(),
                );
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
