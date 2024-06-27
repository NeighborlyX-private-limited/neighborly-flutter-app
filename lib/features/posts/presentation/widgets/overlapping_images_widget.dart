import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OverlappingImages extends StatelessWidget {
  final List<String> images;

  const OverlappingImages({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure the images list has at most 3 images
    List<String> imagesToShow = images.take(3).toList();

    // Calculate total width needed based on overlap
    double imageWidth = 23;
    double overlap = imageWidth / 2; // Each subsequent image overlaps by half
    double totalWidth = (imagesToShow.length - 1) * overlap + imageWidth;

    return SizedBox(
      width: totalWidth,
      height: 24, // Adjust height as needed
      child: Stack(
        children: List.generate(imagesToShow.length, (index) {
          // Calculate the left offset for overlapping effect
          double leftOffset = index * overlap;
          return Positioned(
            left: leftOffset,
            child: SvgPicture.asset(
              imagesToShow[index],
              width: imageWidth,
              height: 24, // Adjust height as needed
            ),
          );
        }),
      ),
    );
  }
}
