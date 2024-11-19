// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:neighborly_flutter_app/core/theme/colors.dart';
// import 'package:video_player/video_player.dart';

// class VideoDisplayWidget extends StatefulWidget {
//   final String videoUrl;

//   const VideoDisplayWidget({super.key, required this.videoUrl});

//   @override
//   _VideoDisplayWidgetState createState() => _VideoDisplayWidgetState();
// }

// class _VideoDisplayWidgetState extends State<VideoDisplayWidget> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     print('in video card');
//     super.initState();
//     // Initialize the video player with the provided URL
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {}); // Update the UI when the video is initialized
//       });
//     _controller.addListener(() {
//       setState(() {
//         if (_controller.value.position == _controller.value.duration) {
//           _controller.seekTo(Duration.zero);
//           _controller.pause();
//           _isPlaying = false;
//         }
//       });
//     });
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//         _isPlaying = false;
//       } else {
//         _controller.play();
//         _isPlaying = true;
//       }
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Dispose the controller to free resources
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? Stack(
//             children: [
//               Column(
//                 children: [
//                   Center(
//                     child: Transform.rotate(
//                       angle: pi / 2,
//                       child: AspectRatio(
//                         aspectRatio: 1 / 1,
//                         child: VideoPlayer(_controller),
//                       ),
//                     ),
//                   ),

//                   VideoProgressIndicator(
//                     _controller,
//                     allowScrubbing: true,
//                     colors: const VideoProgressColors(
//                       playedColor: Colors.blue,
//                       bufferedColor: Colors.grey,
//                       backgroundColor: Colors.black12,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         _formatDuration(_controller.value.position),
//                         style: TextStyle(color: AppColors.primaryColor),
//                       ),
//                       Text(
//                         _formatDuration(_controller.value.duration),
//                         style: TextStyle(color: AppColors.primaryColor),
//                       ),
//                     ],
//                   ),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   children: [
//                   //     IconButton(
//                   //       icon: Icon(
//                   //         _isPlaying ? Icons.pause : Icons.play_arrow,
//                   //       ),
//                   //       onPressed: () {
//                   //         setState(() {
//                   //           if (_isPlaying) {
//                   //             _controller.pause();
//                   //           } else {
//                   //             _controller.play();
//                   //           }
//                   //           _isPlaying = !_isPlaying;
//                   //         });
//                   //       },
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//               Positioned.fill(
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: IconButton(
//                     iconSize: 60,
//                     icon: Icon(
//                       _isPlaying
//                           ? Icons.pause_circle_filled
//                           : Icons.play_circle_filled,
//                       color: Colors.white,
//                     ),
//                     onPressed: _togglePlayPause,
//                   ),
//                 ),
//               ),
//             ],
//           )
//         : Center(
//             child: CircularProgressIndicator(
//               color: AppColors.primaryColor,
//             ),
//           ); // Show a loader until the video is ready
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoDisplayWidget extends StatefulWidget {
  final String videoUrl;

  const VideoDisplayWidget({super.key, required this.videoUrl});

  @override
  _VideoDisplayWidgetState createState() => _VideoDisplayWidgetState();
}

class _VideoDisplayWidgetState extends State<VideoDisplayWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    print('in video card');
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration.zero);
          _controller.pause();
          _isPlaying = false;
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to handle play/pause based on visibility
  void _onVisibilityChanged(VisibilityInfo info) {
    final visibleFraction = info.visibleFraction;
    if (visibleFraction > 0.5 && !_controller.value.isPlaying) {
      _controller.play();
      _isPlaying = true;
    } else if (visibleFraction <= 0.5 && _controller.value.isPlaying) {
      _controller.pause();
      _isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? VisibilityDetector(
            key: Key('video-widget'),
            onVisibilityChanged: _onVisibilityChanged, // Detect visibility
            child: Stack(
              children: [
                Column(
                  children: [
                    Center(
                      child: Transform.rotate(
                        angle: pi / 2,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppColors.blueColor,
                        bufferedColor: AppColors.greyColor,
                        backgroundColor: Colors.black12,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_controller.value.position),
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        Text(
                          _formatDuration(_controller.value.duration),
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      iconSize: 60,
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: AppColors.greyColor,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
