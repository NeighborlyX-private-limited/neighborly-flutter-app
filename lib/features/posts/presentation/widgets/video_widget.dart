import 'dart:math';
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoDisplayWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;

  const VideoDisplayWidget(
      {super.key, required this.videoUrl, required this.thumbnailUrl});

  @override
  VideoDisplayWidgetState createState() => VideoDisplayWidgetState();
}

class VideoDisplayWidgetState extends State<VideoDisplayWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showThumbnail = true;
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();
    print('in video card');
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isMuted = true;
          _controller.setVolume(0.0);
        });
      });

    _controller.addListener(() {
      setState(() {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration.zero);
          _controller.pause();
          _isPlaying = false;
          _showThumbnail = true;
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

  void _onThumbnailVisibilityChanged(VisibilityInfo info) {
    final visibleFraction = info.visibleFraction;
    if (visibleFraction > 0.5 && !_controller.value.isPlaying) {
      setState(() {
        _showLoading = true; // Hide thumbnail
      });
      setState(() {
        _controller.initialize().then((_) {
          _showThumbnail = false;
          _showLoading = false; // Hide thumbnail
          _controller.play();
          _isPlaying = true;
        });
      });
    } else if (visibleFraction <= 0.5 && _controller.value.isPlaying) {
      setState(() {
        _controller.initialize().then((_) {
          _showThumbnail = true;
          _controller.pause();
          _isPlaying = false;
        });
      });
      _controller.pause();
      _isPlaying = false;
      _showThumbnail = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_showThumbnail)
        ? GestureDetector(
            onTap: () {
              setState(() {
                _showLoading = true; // Hide thumbnail
              });
              setState(() {
                _controller.initialize().then((_) {
                  _showThumbnail = false;
                  _showLoading = false; // Hide thumbnail
                  _controller.play();
                  _isPlaying = true;
                });
              });
            },
            child: Stack(
              alignment: Alignment.center, // Center child widgets
              children: [
                // Thumbnail image
                AspectRatio(
                    aspectRatio: 1 / 1.2,
                    child: widget.thumbnailUrl != ''
                        ? Image.network(
                            widget.thumbnailUrl,
                            fit: BoxFit.cover,
                          )
                        : SizedBox()),
                // Play button on top of the thumbnail

                _showLoading
                    ? CircularProgressIndicator()
                    : Icon(
                        Icons.play_circle_filled,
                        color: widget.thumbnailUrl != ''
                            ? AppColors.whiteColor
                            : AppColors.primaryColor,
                        size: 60,
                      ),
              ],
            ),
          )
        : _controller.value.isInitialized
            ? VisibilityDetector(
                key: Key('video-widget'),
                onVisibilityChanged: _onVisibilityChanged, // Detect visibility
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1.2,
                      child: VideoPlayer(_controller),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                                color: AppColors.whiteColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isMuted = !_isMuted;
                                  _controller.setVolume(_isMuted ? 0.0 : 1.0);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                                style: TextStyle(
                                    color: AppColors.lightBackgroundColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: AppColors.primaryColor,
                            bufferedColor: AppColors.greyColor,
                            backgroundColor: AppColors.blackColor.withOpacity(0.12),
                          ),
                        ),
                      ),
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
                            color: AppColors.whiteColor,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: 500,
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )));
  }
}
