import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/option_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/option_card.dart';

class PollWidget extends StatelessWidget {
  final PostEntity post;
  const PollWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    double calculateTotalVotes(List<OptionEntity> options) {
      double totalVotes = 0;

      for (var option in options) {
        // Parse the votes as an integer and add to the total sum.
        totalVotes += double.parse(option.votes);
      }

      return totalVotes;
    }

    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: post.proPic != null
                            ? Image.network(
                                post.proPic!,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                'assets/second_pro_pic.png',
                                fit: BoxFit.contain,
                              )),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              formatTimeDifference(post.createdAt),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          post.city,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${post.title}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            for (var option in post.pollOptions!)
              OptionCard(
                option: option,
                totalVotes: calculateTotalVotes(post.pollOptions!),
                pollId: post.id.toString(),
              ),
          ],
        ));
  }
}
