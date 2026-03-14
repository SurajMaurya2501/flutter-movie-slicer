import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPreview extends StatelessWidget {
  final VideoPlayerController videoController;
  final File? videoFile;
  final Duration? videoDuration;

  const CustomVideoPreview({
    required this.videoDuration,
    required this.videoController,
    required this.videoFile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final previewMaxHeight = MediaQuery.sizeOf(context).height * 0.3;
    final rawAspectRatio = videoController.value.aspectRatio;
    final aspectRatio = (rawAspectRatio.isFinite && rawAspectRatio > 0)
        ? rawAspectRatio
        : (16 / 9);

    final child = videoController.value.isInitialized
        ? VideoPlayer(videoController)
        : const Center(child: CircularProgressIndicator());

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: previewMaxHeight),
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: child,
            ),
          ),
          Positioned.fill(
            child: videoController.value.isPlaying
                ? const SizedBox.shrink()
                : const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 60,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
