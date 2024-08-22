import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatMessagesSheemer extends StatelessWidget {
  const ChatMessagesSheemer({super.key});

int generateRandomNumber(int min, int max) {
  final Random random = Random();
  return min + random.nextInt(max - min + 1);
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),

            ...List.generate(
              14,
              (index) {
                var randomNum = generateRandomNumber(4, 3000);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                   mainAxisAlignment: randomNum.isEven ?  MainAxisAlignment.start :  MainAxisAlignment.end,
                    children: [
                      
                      Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: MediaQuery.of(context).size.width *0.70,
                              height: 60,
                              decoration: BoxDecoration(color: Colors.grey[300], 
                              borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                    ],
                  ),
                );
              },
            ),
            // ListView(
            //   children: List.generate(
            //     4,
            //     (index) {
            //       return Row(
            //         children: [
            //           Expanded(
            //             child: Shimmer.fromColors(
            //               baseColor: Colors.grey[300]!,
            //               highlightColor: Colors.grey[100]!,
            //               child: Container(
            //                 // width: 180,
            //                 // height: MediaQuery.of(context).size.width * 0.4,
            //                 height: 230,
            //                 color: Colors.grey[300],
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 20,
            //           ),
            //           Shimmer.fromColors(
            //             baseColor: Colors.grey[300]!,
            //             highlightColor: Colors.grey[100]!,
            //             child: Container(
            //               width: 180,
            //               height: 230,
            //               color: Colors.grey[300],
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
