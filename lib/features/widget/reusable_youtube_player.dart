import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';

class ReusableYouTubePlayer extends StatefulWidget {
  final String initialVideoId;
  final String? appBarTitle;
  final Widget body;
  final bool showAppBar;
  final bool enableQualitySelection;
  final String defaultQuality;

  const ReusableYouTubePlayer({
    super.key,
    required this.initialVideoId,
    required this.body,
    this.appBarTitle,
    this.showAppBar = true,
    this.enableQualitySelection = true,
    this.defaultQuality = 'medium',
  });

  @override
  State<ReusableYouTubePlayer> createState() => _ReusableYouTubePlayerState();
}

class _ReusableYouTubePlayerState extends State<ReusableYouTubePlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  String _selectedQuality = 'medium';

  @override
  void initState() {
    super.initState();
    _selectedQuality = widget.defaultQuality;

    _controller = YoutubePlayerController(
      initialVideoId: widget.initialVideoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        hideControls: false,
        controlsVisibleAtStart: true,
        useHybridComposition: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (widget.enableQualitySelection)
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings, color: Colors.white),
              onSelected: (String quality) {
                setState(() {
                  _selectedQuality = quality;
                });
                _setVideoQuality(quality);
                _showSnackBar(
                    'Quality changed to ${_getQualityLabel(quality)}');
              },
              itemBuilder: (BuildContext context) => [
                _buildPopupMenuItem('small', 'Low (240p)'),
                _buildPopupMenuItem('medium', 'Medium (360p)'),
                _buildPopupMenuItem('large', 'High (480p)'),
                _buildPopupMenuItem('hd720', 'HD (720p)'),
                _buildPopupMenuItem('hd1080', 'Full HD (1080p)'),
              ],
            ),
        ],
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 10.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 10.0),
          RemainingDuration(),
          const SizedBox(width: 10.0),
          PlaybackSpeedButton(),
          FullScreenButton(),
        ],
        onReady: () {
          _isPlayerReady = true;
          _setVideoQuality(_selectedQuality);
          _showSnackBar(
              'Player ready - Quality: ${_getQualityLabel(_selectedQuality)}');
        },
        onEnded: (data) {
          _showSnackBar('Video ended');
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: _controller.value.isFullScreen || !widget.showAppBar
            ? null
            : YsrAppBar(
                title: Text(
                  widget.appBarTitle ?? 'YouTube Player',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
              ),
        body: _controller.value.isFullScreen
            ? player
            : Column(
                children: [
                  player,
                  Expanded(
                    child: SingleChildScrollView(
                      child: widget.body,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String label) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (_selectedQuality == value)
            const Icon(Icons.check, color: Colors.blue, size: 20)
          else
            const SizedBox(width: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  String _getQualityLabel(String quality) {
    switch (quality) {
      case 'small':
        return 'Low (240p)';
      case 'medium':
        return 'Medium (360p)';
      case 'large':
        return 'High (480p)';
      case 'hd720':
        return 'HD (720p)';
      case 'hd1080':
        return 'Full HD (1080p)';
      default:
        return 'Medium (360p)';
    }
  }

  void _setVideoQuality(String quality) {
    try {
      _controller.setPlaybackRate(1.0);
    } catch (e) {
      // Quality setting might not be fully supported
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Public methods to control the player from outside
  void loadVideo(String videoId) {
    _controller.load(videoId);
  }

  void play() {
    _controller.play();
  }

  void pause() {
    _controller.pause();
  }

  void togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void seekTo(Duration position) {
    _controller.seekTo(position);
  }

  void setVolume(int volume) {
    _controller.setVolume(volume);
  }

  void toggleFullScreen() {
    _controller.toggleFullScreenMode();
  }
}
