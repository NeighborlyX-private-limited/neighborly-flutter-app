import 'package:flutter/material.dart';

class MediaMessageWidget extends StatefulWidget {
  final String fileUrl;

  const MediaMessageWidget({required this.fileUrl, super.key});

  @override
  MediaMessageWidgetState createState() => MediaMessageWidgetState();
}

class MediaMessageWidgetState extends State<MediaMessageWidget> {
  // String? localFilePath;
  @override
  void initState() {
    super.initState();
    print('file Path: ${widget.fileUrl}');
  }

  bool isImage(String url) =>
      RegExp(r'\.(jpg|jpeg|png|gif)$', caseSensitive: false).hasMatch(url);
  bool isVideo(String url) =>
      RegExp(r'\.(mp4|mov|avi)$', caseSensitive: false).hasMatch(url);
  bool isDocument(String url) =>
      RegExp(r'\.(pdf|doc|docx|txt|xlsx|pptx)$', caseSensitive: false)
          .hasMatch(url);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildMediaPreview(),
      ],
    );
  }

// MEDIA PREVIEW
  Widget _buildMediaPreview() {
    if (isImage(widget.fileUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.fileUrl,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return AnimatedOpacity(
              opacity: 0.5,
              duration: const Duration(milliseconds: 500),
              child: child,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              ),
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Widget _buildDocumentPreview() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.grey[300],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: InkWell(
  //       onTap:  null,
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.insert_drive_file,
  //                 size: 50, color: AppColors.primaryColor),
  //             const SizedBox(height: 5),
  //             Text(
  //               widget.fileUrl.split('/').last,
  //               style: const TextStyle(fontSize: 14),
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
