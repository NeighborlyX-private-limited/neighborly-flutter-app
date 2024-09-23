import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/entities/post_enitity.dart';
import '../../../../core/theme/colors.dart';
import '../../../posts/presentation/widgets/post_sheemer_widget.dart';
import '../../../posts/presentation/widgets/post_widget.dart';

class CommunitySectionPosts extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final List<PostEntity> posts;
  final Function(String) onReport;
  final Function(String) onDelete;
  final Function(String) onTap;
  final Function(String) onReact;

  const CommunitySectionPosts({
    Key? key,
    required this.isLoading,
    required this.isEmpty,
    required this.posts,
    required this.onReport,
    required this.onDelete,
    required this.onTap,
    required this.onReact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.lightBackgroundColor,
      // color: AppColors.lightBackgroundColor,
      child: isLoading
          ? PostSheemerWidget()
          : isEmpty
              ? PostListEmpty()
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: PostWidget(
                        post: posts[index],
                        onDelete: (){
                              }
                      ),
                    );
                  }),
    );
  }
}

class PostListEmpty extends StatelessWidget {
  const PostListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey,
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text('No posts so far'),
          ),
        ],
      ),
    );
  }
}
