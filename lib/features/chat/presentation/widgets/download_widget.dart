// import 'package:flutter/material.dart';
// import 'package:image_downloader/image_downloader.dart';


// class ChatImage extends StatelessWidget {
//   final String imageUrl;

//   const ChatImage({super.key, required this.imageUrl});

//   void _downloadImage() async {
//     try {
//       var imageId = await ImageDownloader.downloadImage(imageUrl);
//       if (imageId == null) {
//         print("Download failed");
//         return;
//       }
//       print("Image downloaded successfully");
//     } catch (e) {
//       print("Error downloading image: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _downloadImage,
//       child: Image.network(imageUrl),
//     );
//   }
// }