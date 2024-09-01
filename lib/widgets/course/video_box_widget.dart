import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_box/video_box.dart';

class VideoBoxWidget extends StatefulWidget {
  final String url;
  const VideoBoxWidget({required this.url, super.key});

  @override
  State<VideoBoxWidget> createState() => _VideoBoxWidgetState();
}

class _VideoBoxWidgetState extends State<VideoBoxWidget> {
  late VideoController vc;

  @override
  void initState() {
    vc = VideoController(
        source: VideoPlayerController.networkUrl(Uri.parse(widget.url)))
      ..addInitializeErrorListenner((e) {
        if (kDebugMode) {
          print('[video box init] error: ' + e.message);
        }
      })
      ..initialize().then((e) {
        if (e != null) {
          if (kDebugMode) {
            print('[video box init] error: ' + e.message);
          }
        } else {
          if (kDebugMode) {
            print('[video box init] success');
          }
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    vc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VideoBox(controller: vc),
    );
  }
}
