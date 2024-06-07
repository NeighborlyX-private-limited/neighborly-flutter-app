import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/features/home/widgets/reaction_widget.dart';


class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
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
                      'assets/first_pro_pic.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Cameron Williamson',
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
                      Text(
                        'United States',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500],
                            fontSize: 14),
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
            height: 12,
          ),
          RichText(
            text: TextSpan(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla paria...',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15,
                height: 1.3,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'See more',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const ReactionWidget(
            second: true,
            third: true,
          )
        ],
      ),
    );
  }
}
