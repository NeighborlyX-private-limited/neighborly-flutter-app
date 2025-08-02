import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/mutiImage_popup_slider.dart';

class ImageSlider extends StatefulWidget {
  final List<String> multimedia;

  const ImageSlider({super.key, required this.multimedia});

  @override
  ImageSliderState createState() => ImageSliderState();
}

class ImageSliderState extends State<ImageSlider> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierColor:
                  Colors.black.withOpacity(0.7), // Optional background dim
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding:
                      EdgeInsets.all(20), // Controls popup size/margin
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MultiImageImageSlider(multimedia: widget.multimedia),
                  ),
                );
              },
            );
          },
          child: SizedBox(
            height: 300,
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
                    panEnabled: true, // allows dragging
                    scaleEnabled: true, // allows zooming
                    minScale: 1.0, // no zoom out beyond original
                    maxScale: 4.0, // max 4x zoom in
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
