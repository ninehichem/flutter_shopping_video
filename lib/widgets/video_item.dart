import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_shop_flutter/model/video_model.dart';
import 'package:video_shop_flutter/widgets/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoItem extends StatefulWidget {
  /// Create video item.
  const VideoItem({
    Key? key,
    required this.video,
    required this.videoWatched,
    required this.updateLastSeenPage,
    required this.index,
    required this.videoController,
  }) : super(key: key);
  final VideoModel video;
  final List<String> videoWatched;
  final Function(int lastSeenPage)? updateLastSeenPage;
  final int index;
  final VideoPlayerController videoController;
  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
    VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _videoController  = widget.videoController;
  }


  // @override
  // void dispose() async{
  //   super.dispose();
  //   if(_videoController != null){
  //     if(_videoController!.value.isPlaying){
  //       _videoController!.pause();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return _videoController != null && _videoController!.value.isInitialized
        ? VisibilityDetector(
            onVisibilityChanged: (visibleInfo) {
              if (visibleInfo.visibleFraction > 0.8) {
                if (!_videoController!.value.isPlaying) {
                  _videoController!.play();
                  _videoController!.setLooping(true);
                  // Update watched videos.
                  if (widget.video.id != null) {
                    widget.videoWatched.add(widget.video.id!.toString());
                  }
                  // Update last seen video.
                  if (widget.updateLastSeenPage != null) {
                    widget.updateLastSeenPage!(widget.index);
                  }
                }
              }
              if(visibleInfo.visibleFraction == 0){
                if(_videoController! != null){
                  if(_videoController!.value.isPlaying){
                    _videoController!.pause();
                  }
                }
              }
            },
            key: UniqueKey(),
            child: VideoPlayerApp(
              controller: _videoController!,
            ),
          )
        : VisibilityDetector(
            key: UniqueKey(),
            child: Image.network(
              widget.video.thumbnail ?? "",
              loadingBuilder: (context, child, loadingProgress) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(
                    child:_videoController!.value.isPlaying? const Icon(Icons.play_arrow, size: 80, color: Colors.grey) : const CupertinoActivityIndicator(color: Colors.white,),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(
                    child: _videoController!.value.isPlaying? const Icon(Icons.play_arrow, size: 80, color: Colors.grey) : const CupertinoActivityIndicator(color: Colors.white,),
                  ),
                );
              },
              fit: BoxFit.fitWidth,
            ),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.6) {
                _videoController =
                    VideoPlayerController.network(widget.video.url)
                      ..initialize().then(
                        (_) {
                          setState(() {});
                        },
                      );
              }
            },
          );
  }
}
