import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_comment_widget.dart';

class CommentWidget extends StatelessWidget {
  final CommentEntity comment;
  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: comment.proPic != null
                ? Image.network(
                    comment.proPic!,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/second_pro_pic.png',
                    fit: BoxFit.contain,
                  )),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                comment.text,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    timeAgo(comment.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Reply',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ReactionCommentWidget(
                comment: comment,
              )
            ],
          ),
        ),
      ],
    );
  }
}
