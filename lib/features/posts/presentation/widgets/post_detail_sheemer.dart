import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostDetailSheemer extends StatelessWidget {
  const PostDetailSheemer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    // Profile picture shimmer
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User name shimmer
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 14,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // City and time shimmer
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 150,
                            height: 14,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // More icon shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Icon(
                    Icons.more_horiz,
                    size: 30,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            // Title Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 20,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 10),
            // Content Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.grey[300],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            // Multimedia Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 10),
            // Date Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 14,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 20),
            // Reactions shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Comment Text Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Time Ago and Reply Shimmer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Time Ago Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Reply Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Reaction Widget Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Comment Text Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Time Ago and Reply Shimmer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Time Ago Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Reply Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Reaction Widget Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Comment Text Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Time Ago and Reply Shimmer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Time Ago Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Reply Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Reaction Widget Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Comment Text Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Time Ago and Reply Shimmer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Time Ago Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Reply Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Reaction Widget Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Comment Text Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Time Ago and Reply Shimmer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Time Ago Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Reply Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Reaction Widget Shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
