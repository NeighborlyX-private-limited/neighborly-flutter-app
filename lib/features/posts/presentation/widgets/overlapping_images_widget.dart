import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OverlappingImages extends StatelessWidget {
  final List<String> images;

  const OverlappingImages({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    List<String> imagesToShow = images.take(3).toList();

    double imageWidth = 23;
    double overlap = imageWidth / 2;
    double totalWidth = (imagesToShow.length - 1) * overlap + imageWidth;

    return SizedBox(
      width: totalWidth,
      height: 24,
      child: Stack(
        children: List.generate(
          imagesToShow.length,
          (index) {
            double leftOffset = index * overlap;
            return Positioned(
              left: leftOffset,
              child: SvgPicture.asset(
                imagesToShow[index],
                width: imageWidth,
                height: 24,
              ),
            );
          },
        ),
      ),
    );
  }
}
