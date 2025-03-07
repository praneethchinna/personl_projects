import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/widgets/video_card.dart';

class SpecialVideosPage extends ConsumerWidget {
  const SpecialVideosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialVideos = ref.watch(specialVideoProvider);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Special Videos",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: specialVideos.when(
          data: (data) {
            return RefreshIndicator.adaptive(
              onRefresh: () async {
                ref.invalidate(futureNotificatonProvider);
              },
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  final video = data[index];

                  return VideoCard(
                    channelName: "SLOM YSRCP",
                    title: video.title,
                    onShare: () {},
                    subtitle: "",
                    videoUrl: video.videoUrl,
                    postedDate: video.createdTime,
                    showChannelName: false,
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(child: Text(error.toString()));
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }
}
