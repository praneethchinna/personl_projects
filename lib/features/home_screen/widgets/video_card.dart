import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';

class VideoCard extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String subtitle;
  final VoidCallback onShare;
  final DateTime postedDate;

  const VideoCard({
    Key? key,
    required this.videoUrl,
    required this.title,
    required this.subtitle,
    required this.onShare,
    required this.postedDate,
  }) : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late YoutubePlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.notifications_active,color: AppColors.primaryColor,),
              Gap(10),
              Text(
                "Check out this new Video",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Gap(10),
              Text(
                "SLOM YSRCP",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/image_2.png"), // Change as needed
                      radius: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "WeYSRCP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("MMMM d, y").format(widget.postedDate),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    isPlaying
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(widget.videoUrl)}/hqdefault.jpg',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                    if (!isPlaying)
                      Positioned.fill(
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isPlaying = true;
                                _controller.play();
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              radius: 24,
                              child: const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 30),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (widget.subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              Divider(
                endIndent: 10,
                indent: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _socialButton(FontAwesomeIcons.whatsapp, Colors.green, () {
                      ShareCard(title: widget.title, link: widget.videoUrl)
                          .shareOnSocialMedia(context, "whatsapp");
                    }, "Whatsapp"),
                    _socialButton(
                        FontAwesomeIcons.facebook,
                        Colors.blue,
                        () => ShareCard(
                                title: widget.title, link: widget.videoUrl)
                            .shareOnSocialMedia(context, "facebook"),
                        "facebook"),
                    _socialButton(
                        FontAwesomeIcons.twitter,
                        Colors.lightBlue,
                        () => ShareCard(
                                title: widget.title, link: widget.videoUrl)
                            .shareOnSocialMedia(context, "twitter"),
                        "twitter"),
                    Spacer(),
                    _socialButton(
                        Icons.share,
                        Colors.black54,
                        () => ShareCard(
                                title: widget.title, link: widget.videoUrl)
                            .shareOnSocialMedia(context, "share"),
                        "generic"),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(20)
      ],
    );
  }

  Widget _socialButton(
      IconData icon, Color color, VoidCallback onTap, String data) {
    return Row(
      children: [
        IconButton(
          onPressed: onTap,
          icon: FaIcon(icon, color: color),
        ),
        Text(
          "share",
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
