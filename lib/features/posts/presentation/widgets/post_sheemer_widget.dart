import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPost extends StatelessWidget {
  const ShimmerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const PostSheemerWidget();
      },
    );
  }
}

class PostSheemerWidget extends StatelessWidget {
  const PostSheemerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
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
                    Shimmer.fromColors(
                      child: CircleAvatar(
                        radius: 20.0, // Adjust radius as needed
                        backgroundColor: Colors.grey[200],
                      ),
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          child: Text(
                            'Username',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                        ),
                        const SizedBox(width: 6),
                        Shimmer.fromColors(
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                          ),
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                        ),
                        const SizedBox(width: 6),
                        Shimmer.fromColors(
                          child: Text(
                            '...',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
                // ... (Include placeholder for optional "more_horiz" icon)
              ],
            ),
            const SizedBox(height: 12),
            // ... (Include placeholder Shimmers for title and content)
            const SizedBox(height: 10),
            // ... (Include placeholder Shimmer for multimedia)
            const SizedBox(height: 20),
            Shimmer.fromColors(
              child: Container(
                height: 50, // Adjust height as needed
                width: double.infinity, // Match container width
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
            ),
          ],
        ),
      ),
    );
  }
}
