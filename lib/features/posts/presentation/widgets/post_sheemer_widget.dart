import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class PostSheemerWidget extends StatelessWidget {
  const PostSheemerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const OnePostSheemer();
      },
    );
  }
}

class OnePostSheemer extends StatelessWidget {
  const OnePostSheemer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
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
          const SizedBox(height: 12),
          // Title shimmer
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
          // Content shimmer
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
          // Image shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 200,
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
          )
        ],
      ),
    );
  }
}
