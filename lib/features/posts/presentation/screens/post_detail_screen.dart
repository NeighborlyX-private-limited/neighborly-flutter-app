import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_widget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
              size: 15,
            ),
            onTap: () {
              // context.pop();
            },
          ),
          centerTitle: true,
          title: Row(
            children: [
              const SizedBox(width: 100),
              Text(
                'Post',
                style: blackNormalTextStyle,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: SingleChildScrollView(
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
                              const Text(
                                'Oleg Ivanov',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.more_horiz,
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Mar 20, 19:56 PM',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const ReactionWidget(
                        second: true,
                        third: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cameron Williamson',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Simultaneously we had a problem with prisoner drunkenness that we couldn’t figure out. I mean, the ',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '5 hours ago',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        height: 1.3,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
