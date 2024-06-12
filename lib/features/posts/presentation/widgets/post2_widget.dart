import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/option_card.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_widget.dart';

class Post2Widget extends StatelessWidget {
  const Post2Widget({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: Image.asset(
                        'assets/second_pro_pic.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Oleg Ivanov',
                          style: TextStyle(
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
                          '1m',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey[500],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Question 1',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const OptionCard(
              title: 'Option 1',
              color: Color.fromARGB(255, 90, 92, 245),
              titleColor: Colors.white,
              action: '100%',
            ),
            const SizedBox(
              height: 8,
            ),
            const OptionCard(
              title: 'Option 2',
              color: Colors.white,
              titleColor: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            // const ReactionWidget(
            //   second: false,
            //   third: false,
            // )
          ],
        ));
  }
}
