import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    print('in video card');
    super.initState();
    // Initialize the video player with the provided URL
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: VideoPlayer(_controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          ); // Show a loader until the video is ready
  }
}
