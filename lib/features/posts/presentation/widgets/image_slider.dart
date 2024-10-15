import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> multimedia;

  const ImageSlider({Key? key, required this.multimedia}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Get the full width of the screen
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Image slider
        Container(
          height: 300, // Fixed height for images
          width: screenWidth, // Full width of the screen
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
                child: CachedNetworkImage(
                  imageUrl: widget.multimedia[index],
                  fit: BoxFit.cover, // Ensures the image covers the whole area
                  width: screenWidth, // Ensure full width of the screen
                  height: 350, // Ensure fixed height
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                      Icons.error), // Show error icon if image fails to load
                ),
              );
            },
          ),
        ),
        // Indicator showing the current image position
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.multimedia.map((url) {
            int index = widget.multimedia.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blueAccent : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
