import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_tab_screen.dart';
import 'package:ysr_project/features/home_screen/widgets/video_card.dart';
import 'package:ysr_project/main.dart';

class InfluencerVideoUI extends ConsumerWidget {
  final bool showAppBar;
  const InfluencerVideoUI({this.showAppBar = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(influencerVideoProvider);
    final currentLocale = ref.watch(languageProvider);

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              foregroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                "influencer_videos".tr(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: AppColors.secondaryColor,
              elevation: 0,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: state.when(
          data: (data) {
            return RefreshIndicator.adaptive(
              onRefresh: () async {
                ref.invalidate(influencerVideoProvider);
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
                    channelName: video.channelName,
                    title: video.title,
                    onShare: () {},
                    subtitle: "",
                    videoUrl: video.url,
                    postedDate: video.publishedAt,
                    showChannelName: true,
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
