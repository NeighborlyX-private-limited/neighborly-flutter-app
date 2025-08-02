import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';

class MultiImageImageSlider extends StatefulWidget {
  final List<String> multimedia;

  const MultiImageImageSlider({super.key, required this.multimedia});

  @override
  ImageSliderState createState() => ImageSliderState();
}

class ImageSliderState extends State<MultiImageImageSlider> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: screenWidth,
          child: PageView.builder(
            itemCount: widget.multimedia.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: widget.multimedia[index],
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: 300,
                    placeholder: (context, url) => Center(
                      child: CustomCircularIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline_outlined),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.multimedia.map(
              (url) {
                int index = widget.multimedia.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColors.primaryColor
                        : AppColors.greyColor,
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
