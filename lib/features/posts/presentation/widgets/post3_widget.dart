import 'package:flutter/material.dart';

class Post3Widget extends StatelessWidget {
  const Post3Widget({super.key});

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
                      'assets/third_pro_pic.png',
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
            height: 8,
          ),
          Text(
            'Lorem ipsum dolor sit amet,',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  width: double.infinity,
                  height: 200,
                  'assets/big_image.png',
                  fit: BoxFit.cover,
                )),
          )
        ],
      ),
    );
  }
}
