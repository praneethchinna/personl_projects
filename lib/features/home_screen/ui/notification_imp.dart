import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/widgets/video_card.dart';

class NotificationImp extends ConsumerWidget {
  const NotificationImp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationResponse = ref.watch(futureNotificatonProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notificatons",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: notificationResponse.when(
          data: (data) {
            return RefreshIndicator.adaptive(
              onRefresh: () async {
                ref.invalidate(futureNotificatonProvider);
              },
              child: ListView.separated(
                itemCount: data.latestVideos.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  final video = data.latestVideos[index];
                  log(video.url);
                  log(video.title);
                  return VideoCard(
                    title: video.title,
                    onShare: () {},
                    subtitle: "",
                    videoUrl: video.url,
                    postedDate: video.publishedAt,
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
