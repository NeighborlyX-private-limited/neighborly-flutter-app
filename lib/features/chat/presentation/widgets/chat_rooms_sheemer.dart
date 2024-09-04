import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatRoomsSheemer extends StatelessWidget {
  const ChatRoomsSheemer({super.key});

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
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                               height: 5,
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 120,
                                height: 19,
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(
                               height: 7,
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 80,
                                height: 19,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 60,
                          height: 19,
                          color: Colors.grey[300],
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
