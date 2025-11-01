import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:video_player/video_player.dart';

class MediaCarousel extends StatefulWidget {
  final List<String> mediaUrls;
  final void Function(String currentUrl) onUrlChanged;
  final double borderRadius;
  final double height;

  const MediaCarousel({
    super.key,
    required this.mediaUrls,
    required this.onUrlChanged,
    this.borderRadius = 12.0,
    this.height = 300,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  List<FlickManager?> flickManagers = [];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.mediaUrls.length, vsync: this);

    flickManagers = widget.mediaUrls.map((url) {
      return _isVideo(url)
          ? FlickManager(
              autoPlay: false,
              videoPlayerController:
                  VideoPlayerController.networkUrl(Uri.parse(url)),
            )
          : null;
    }).toList();

    _tabController.animation?.addListener(() {
      final newIndex = _tabController.animation!.value.round();
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
          widget.onUrlChanged(widget.mediaUrls[_currentIndex]);
        });
      }
    });
  }

  @override
  void dispose() {
    for (var manager in flickManagers) {
      manager?.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  bool _isVideo(String url) {
    return url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.avi');
  }

  Future<Size> _getImageSize(String url) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(url);

    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              physics: BouncingScrollPhysics(),
              children: widget.mediaUrls.map((url) {
                return _isVideo(url)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Optional border color
                              width: 0.6, // Optional border width
                            ),
                          ),
                          child: FlickVideoPlayer(
                            preferredDeviceOrientationFullscreen: [
                              DeviceOrientation.portraitUp,
                            ],
                            flickManager:
                                flickManagers[widget.mediaUrls.indexOf(url)]!,
                            flickVideoWithControls: FlickVideoWithControls(
                              controls: FlickPortraitControls(),
                              videoFit: BoxFit.cover,
                            ),
                          ),
                        ))
                    : FutureBuilder<Size>(
                        future: _getImageSize(url),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error loading image'));
                          }
                          if (!snapshot.hasData) {
                            return Center(
                                child: CircularProgressIndicator.adaptive());
                          }

                          double aspectRatio =
                              snapshot.data!.width / snapshot.data!.height;
                          return Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black, // Optional border color
                                  width: 0.6, // Optional border width
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: InstaImageViewer(
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.contain,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }).toList(),
            ),
          ),
        ),
        if (widget.mediaUrls.length > 1) ...[
          const SizedBox(height: 10),
          _buildDotsIndicator(),
        ]
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.mediaUrls.length, (index) {
        return GestureDetector(
          onTap: () => _tabController.animateTo(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: _currentIndex == index ? 8 : 6,
            height: _currentIndex == index ? 8 : 6,
            decoration: BoxDecoration(
              color: _currentIndex == index ? Colors.black : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
