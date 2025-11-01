import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/widgets/video_card.dart';

class NotificationImp extends ConsumerWidget {
  const NotificationImp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationResponse = ref.watch(futureNotificatonProvider);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "notifications".tr(),
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
                  try {
                    final video = data.latestVideos[index];
                    log(video.url);
                    log(video.title);

                    return VideoCard(
                      channelName: video.channelName,
                      title: video.title,
                      onShare: () {},
                      subtitle: "",
                      videoUrl: video.url,
                      postedDate: video.publishedAt,
                    );
                  } catch (e) {
                    SizedBox.shrink();
                  }
                  return null;
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
