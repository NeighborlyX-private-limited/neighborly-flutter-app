import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OverlappingImages extends StatelessWidget {
  final List<String> images;

  const OverlappingImages({
    super.key,
    required this.images,
  }) : assert(images.length <= 3, 'The widget can accept at most 3 images.');

  @override
  Widget build(BuildContext context) {
    // Ensure the images list has at most 3 images
    List<String> imagesToShow = images.take(3).toList();

    // Calculate the overlap and width based on container width
    double containerWidth = 60; // Container width from parent
    double imageWidth = 20;
    double overlap =
        (containerWidth - imageWidth) / 2; // Calculate dynamic overlap

    return SizedBox(
      width: containerWidth,
      height: 32,
      child: Stack(
        children: List.generate(imagesToShow.length, (index) {
          // Calculate the left offset for overlapping effect
          double leftOffset = index * overlap;
          return Positioned(
            left: leftOffset,
            child: SvgPicture.asset(
              imagesToShow[index],
              width: imageWidth,
              height: 24, // Adjust as needed
            ),
          );
        }),
      ),
    );
  }
}
