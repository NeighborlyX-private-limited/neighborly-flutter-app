import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

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
        SizedBox(
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
                child: CachedNetworkImage(
                  imageUrl: widget.multimedia[index],
                  fit: BoxFit.cover,
                  width: screenWidth,
                  height: 300,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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

//     return Stack(
//        alignment: Alignment.bottomCenter,
//       children: [ Column(
//         children: [
//           SizedBox(
//             height: 300,
//             width: screenWidth,
//             child: PageView.builder(
//               itemCount: widget.multimedia.length,
//               onPageChanged: (int index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//               itemBuilder: (context, index) {
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: CachedNetworkImage(
//                     imageUrl: widget.multimedia[index],
//                     fit: BoxFit.cover,
//                     width: screenWidth,
//                     height: 350,
//                     placeholder: (context, url) => Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.primaryColor,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//              bottom: 10.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: widget.multimedia.map(
//                 (url) {
//                   int index = widget.multimedia.indexOf(url);
//                   return Container(
//                     width: 8.0,
//                     height: 8.0,
//                     margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _currentPage == index
//                           ? AppColors.primaryColor
//                           : AppColors.greyColor,
//                     ),
//                   );
//                 },
//               ).toList(),
//             ),
//           ),
//         ],
//       ),
//     ]);
//   }
// }
