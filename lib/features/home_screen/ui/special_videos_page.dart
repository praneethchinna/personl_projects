import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/widgets/video_card.dart';
import 'package:ysr_project/main.dart';

class SpecialVideosPage extends ConsumerWidget {
  final bool showAppBar;
  const SpecialVideosPage({this.showAppBar = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    final specialVideos = ref.watch(specialVideoProvider);
    return Scaffold(
      appBar: YsrAppBar(
        centerTitle: true,
        title: Text(
          "special_videos".tr(),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
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
