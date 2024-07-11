import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/reply_entity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_reply_widget.dart';

class ReplyWidget extends StatefulWidget {
  final ReplyEntity reply;

  const ReplyWidget({super.key, required this.reply});

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipOval(
        child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: widget.reply.proPic != null
                ? Image.network(
                    widget.reply.proPic!,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/second_pro_pic.png',
                    fit: BoxFit.contain,
                  )),
      ),
      const SizedBox(
        width: 12,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.reply.userName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.reply.text,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15,
                height: 1.3,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  timeAgo(widget.reply.createdAt),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                // const Text(
                //   'Reply',
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontWeight: FontWeight.w500,
                //     fontSize: 14,
                //     height: 1.3,
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ReactionReplyWidget(
              reply: widget.reply,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ]);
  }
}
