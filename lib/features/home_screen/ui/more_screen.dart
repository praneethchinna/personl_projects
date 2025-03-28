import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/gallery/ui/gallary_ui.dart';
import 'package:ysr_project/features/home_screen/helper_class/logout_invalidate_providers.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/response_model/pdf_ui.dart';
import 'package:ysr_project/features/home_screen/ui/influencer_video_ui.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/features/home_screen/ui/special_videos_page.dart';
import 'package:ysr_project/features/home_screen/widgets/video_card.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  Future<void> launchTheUrl(String videoUrl) async {
    final Uri url = Uri.parse(videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      final dio = ref.read(dioProvider);
                      final response = await dio.get('/live-videos');
                      if (response.statusCode == 200) {
                        ShareCard(
                                title: "sakshi tv",
                                link: response.data['video_url'])
                            .launchURL(context);
                      }
                    } catch (e) {
                      log(e.toString());
                    } finally {
                      EasyLoading.dismiss();
                    }
                  },
                  child: _buildMenuItem(Icons.live_tv, "Live", Colors.red),
                ),
                GestureDetector(
                    onTap: () async {
                      ShareCard(
                              title: "sakshi tv",
                              link: "https://epaper.sakshi.com/")
                          .launchURL(context);
                    },
                    child: _buildMenuItem(
                        Icons.description, "E-Paper", Colors.blue)),
                InkWell(
                    onTap: () {
                      ref.read(tabIndexProvider.notifier).state = 1;
                    },
                    child:
                        _buildMenuItem(Icons.bar_chart, "Poll", Colors.green)),
                GestureDetector(
                    onTap: () {
                      ref.read(tabIndexProvider.notifier).state = 0;
                    },
                    child: _buildMenuItem(Icons.home, "Home", Colors.blue)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GalleryScreen(),
                      ));
                    },
                    child:
                        _buildMenuItem(Icons.photo, "Gallery", Colors.purple)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SpecialVideosPage(),
                      ));
                    },
                    child: _buildMenuItem(
                        MdiIcons.youtube, "Special Videos", Colors.redAccent)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InfluencerVideoUI(),
                      ));
                    },
                    child: _buildMenuItem(Icons.person_pin_outlined,
                        "Influencer Videos", Colors.deepOrangeAccent)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PdfListWidget(),
                      ));
                    },
                    child: _buildMenuItem(
                        Icons.picture_as_pdf, "Important PDF's", Colors.red)),
                _buildMenuItem(Icons.help, "Help", Colors.orange),
                _buildMenuItem(Icons.people, "Grievance", Colors.brown),
                _buildMenuItem(Icons.share, "Share", Colors.blueGrey),
                Gap(100),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: const Color.fromARGB(255, 195, 21, 8),
                ),
                onPressed: () async {
                  await LogoutInvalidationProvider.logout(ref, context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Logout", style: TextStyle(color: Colors.white)),
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

final tabIndexProvider = StateProvider<int>((ref) {
  return 0;
});
