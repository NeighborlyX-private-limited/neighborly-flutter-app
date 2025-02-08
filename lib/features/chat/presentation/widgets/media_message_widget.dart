// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:neighborly_flutter_app/core/theme/colors.dart';
// import 'package:video_player/video_player.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// // import 'package:open_file/open_file.dart';

// class MediaMessageWidget extends StatefulWidget {
//   final String fileUrl;

//   const MediaMessageWidget({required this.fileUrl, Key? key}) : super(key: key);

//   @override
//   _MediaMessageWidgetState createState() => _MediaMessageWidgetState();
// }

// class _MediaMessageWidgetState extends State<MediaMessageWidget> {
//   VideoPlayerController? _videoController;
//   bool isDownloading = false;
//   bool isDownloaded = false; // Track if file is downloaded
//   String? localFilePath; // Store the downloaded file path

//   @override
//   void initState() {
//     super.initState();
//     if (isVideo(widget.fileUrl)) {
//       _videoController = VideoPlayerController.network(widget.fileUrl)
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     }

//     _checkIfFileExists(); // Check if the file is already downloaded
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   Future<void> _checkIfFileExists() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = "${dir.path}/${widget.fileUrl.split('/').last}";
//     final file = File(filePath);

//     if (file.existsSync()) {
//       setState(() {
//         isDownloaded = true;
//         localFilePath = filePath;
//       });
//     }
//   }

//   Future<void> downloadFile(String url) async {
//     try {
//       setState(() {
//         isDownloading = true;
//       });

//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final dir = await getApplicationDocumentsDirectory();
//         final filePath = "${dir.path}/${url.split('/').last}";
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         setState(() {
//           isDownloading = false;
//           isDownloaded = true;
//           localFilePath = filePath;
//         });

//         // OpenFile.open(filePath);
//       } else {
//         throw Exception("Failed to download file");
//       }
//     } catch (e) {
//       setState(() {
//         isDownloading = false;
//       });
//       print("Download error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         if (isImage(widget.fileUrl))
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               widget.fileUrl,
//               fit: BoxFit.cover,
//             ),
//           )
//         else if (isVideo(widget.fileUrl) &&
//             _videoController != null &&
//             _videoController!.value.isInitialized)
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: AspectRatio(
//               aspectRatio: _videoController!.value.aspectRatio,
//               child: VideoPlayer(_videoController!),
//             ),
//           )
//         else if (isDocument(widget.fileUrl))
//           Container(
//             //height: 100,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.insert_drive_file,
//                     size: 50,
//                     color: AppColors.primaryColor,
//                   ),
//                   SizedBox(height: 5),
//                   Center(
//                     child: Text(
//                       widget.fileUrl.split('/').last,
//                       style: TextStyle(
//                         fontSize: 14,
//                       ),
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//         // Show Download Button ONLY IF the file is not downloaded
//         if (!isDownloaded)
//           Positioned(
//             child: isDownloading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: CircleBorder(),
//                       padding:
//                           EdgeInsets.zero, // Remove padding to center the icon
//                       backgroundColor: Colors.black54,
//                       minimumSize: Size(50, 50), // Ensures proper circular size
//                     ),
//                     onPressed: () => downloadFile(widget.fileUrl),
//                     child: Icon(Icons.download,
//                         color: Colors.white,
//                         size: 24), // Ensure proper icon size
//                   ),

//             // : ElevatedButton.icon(
//             //     style: ElevatedButton.styleFrom(
//             //       shape: CircleBorder(),
//             //       padding: EdgeInsets.all(15),
//             //       backgroundColor: AppColors.primaryColor,
//             //     ),
//             //     onPressed: () => downloadFile(widget.fileUrl),
//             //     icon: Center(
//             //         child:
//             //             Icon(Icons.download, color: AppColors.whiteColor)),
//             //     label: SizedBox(),
//             //   ),
//           ),
//       ],
//     );
//   }
// }

// /// Helper Functions
// bool isImage(String url) {
//   return url.toLowerCase().endsWith('.jpg') ||
//       url.toLowerCase().endsWith('.jpeg') ||
//       url.toLowerCase().endsWith('.png') ||
//       url.toLowerCase().endsWith('.gif');
// }

// bool isVideo(String url) {
//   return url.toLowerCase().endsWith('.mp4') ||
//       url.toLowerCase().endsWith('.mov') ||
//       url.toLowerCase().endsWith('.avi');
// }

// bool isDocument(String url) {
//   return url.toLowerCase().endsWith('.pdf') ||
//       url.toLowerCase().endsWith('.doc') ||
//       url.toLowerCase().endsWith('.docx') ||
//       url.toLowerCase().endsWith('.txt') ||
//       url.toLowerCase().endsWith('.xlsx') ||
//       url.toLowerCase().endsWith('.pptx');
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class MediaMessageWidget extends StatefulWidget {
  final String fileUrl;

  const MediaMessageWidget({required this.fileUrl, Key? key}) : super(key: key);

  @override
  _MediaMessageWidgetState createState() => _MediaMessageWidgetState();
}

class _MediaMessageWidgetState extends State<MediaMessageWidget> {
  VideoPlayerController? _videoController;
  bool isDownloading = false;
  bool isDownloaded = false;
  String? localFilePath;
  double _downloadProgress = 0;
  String? _taskId;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
    _checkExistingFile();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _initializeMedia() {
    if (isVideo(widget.fileUrl)) {
      _videoController = VideoPlayerController.network(widget.fileUrl)
        ..initialize().then((_) => setState(() {}));
    }
  }

  Future<void> _checkExistingFile() async {
    final dir = await getExternalStorageDirectory();
    final filePath = "${dir?.path}/${widget.fileUrl.split('/').last}";
    if (File(filePath).existsSync()) {
      setState(() {
        isDownloaded = true;
        localFilePath = filePath;
      });
    }
  }

  // Update the callback signature to match package requirements
  static void downloadCallback(String id, int status, int progress) {
    // Convert status to DownloadTaskStatus
    // final taskStatus = DownloadTaskStatus(status);

    // // Handle download progress updates
    // if (_taskId == id) {
    //   setState(() {
    //     _downloadProgress = progress.toDouble();
    //     if (taskStatus == DownloadTaskStatus.complete) {
    //       isDownloading = false;
    //       isDownloaded = true;
    //       OpenFile.open(localFilePath!);
    //     } else if (taskStatus == DownloadTaskStatus.failed) {
    //       isDownloading = false;
    //     }
    //   });
    // }
  }
  Future<void> _handleDownload() async {
    // First check current status
    var status = await Permission.storage.status;

    // If denied, request permission
    if (status.isDenied) {
      print('hre');
      status = await Permission.storage.request();
      print('hre:$status');
    }

    // Handle final status
    if (status.isGranted) {
      await _startDownload();
    } else if (status.isPermanentlyDenied) {
      // Guide user to app settings
      openAppSettings();
      showSnackBar(
        context: context,
        message: 'Please enable storage permission in settings',
      );
    } else {
      showSnackBar(
        context: context,
        message: 'Storage permission required',
      );
    }
  }

  // Future<void> _handleDownload() async {
  //   if (await Permission.storage.request().isGranted) {
  //     await _startDownload();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Storage permission required')),
  //     );
  //   }
  // }

  Future<void> _startDownload() async {
    setState(() => isDownloading = true);

    try {
      final dir = await getExternalStorageDirectory();
      final fileName = widget.fileUrl.split('/').last;

      final taskId = await FlutterDownloader.enqueue(
        url: widget.fileUrl,
        savedDir: dir?.path ?? '',
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      FlutterDownloader.registerCallback((id, status, progress) {
        if (id == taskId) {
          setState(() {
            _downloadProgress = progress.toDouble();
            if (status == DownloadTaskStatus.complete) {
              isDownloading = false;
              isDownloaded = true;
              localFilePath = '${dir?.path}/$fileName';
              OpenFile.open(localFilePath);
            } else if (status == DownloadTaskStatus.failed) {
              isDownloading = false;
            }
          });
        }
      });
    } catch (e) {
      setState(() => isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  Future<void> _viewDocument() async {
    if (isDownloaded && localFilePath != null) {
      OpenFile.open(localFilePath!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File not downloaded yet')),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    FlutterDownloader.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildMediaPreview(),
        if (!isDownloaded) _buildDownloadButton(),
      ],
    );
  }

  Widget _buildMediaPreview() {
    if (isImage(widget.fileUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(widget.fileUrl, fit: BoxFit.cover),
      );
    } else if (isVideo(widget.fileUrl) &&
        _videoController?.value.isInitialized == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
      );
    } else if (isDocument(widget.fileUrl)) {
      return _buildDocumentPreview();
    }
    return const SizedBox.shrink();
  }

  Widget _buildDocumentPreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: isDownloaded ? _viewDocument : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_drive_file,
                  size: 50, color: AppColors.primaryColor),
              const SizedBox(height: 5),
              Text(
                widget.fileUrl.split('/').last,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Positioned(
      child: isDownloading
          ? CircularProgressIndicator(value: _downloadProgress / 100)
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.black54,
                minimumSize: const Size(50, 50),
              ),
              onPressed: _handleDownload,
              child: const Icon(Icons.download, color: Colors.white, size: 24),
            ),
    );
  }
}

/// File Type Check Helpers
bool isImage(String url) =>
    RegExp(r'\.(jpg|jpeg|png|gif)$', caseSensitive: false).hasMatch(url);
bool isVideo(String url) =>
    RegExp(r'\.(mp4|mov|avi)$', caseSensitive: false).hasMatch(url);
bool isDocument(String url) =>
    RegExp(r'\.(pdf|doc|docx|txt|xlsx|pptx)$', caseSensitive: false)
        .hasMatch(url);
