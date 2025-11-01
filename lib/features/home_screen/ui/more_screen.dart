// ignore_for_file: avoid_print

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/help/presentation/ui/help_screen.dart';
import 'package:ysr_project/features/important_docs/important_docs.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_ui_temp.dart';
import 'package:ysr_project/features/myrewards/ui/rewards_screen.dart';
import 'package:ysr_project/features/profile/ui/user_profile_ui.dart';
import 'package:ysr_project/main.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ysr_project/features/gallery/ui/gallary_ui.dart';
import 'package:ysr_project/features/home_screen/helper_class/logout_invalidate_providers.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/girievance_tab.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_tab_screen.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ysr_project/services/user/user_data.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  void launchURLExternally(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: YsrAppBar(
        centerTitle: true,
        title: Text("more".tr(),
            style: const TextStyle(color: Colors.black, fontSize: 20)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  _gridItem(context, 'home', 'assets/home.png', () {
                    ref.read(tabIndexProvider.notifier).state = 0;
                  }),
                  _gridItem(context, 'gallery', 'assets/gallery.png', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => GalleryScreen()),
                    );
                  }),
                  _gridItem(context, 'profile', 'assets/profile_small.png',
                      () async {
                    final phNumber = ref.read(userProvider).mobile;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => UserProfileUI(phNumber)),
                    );
                  }),
                  _gridItem(context, 'live', 'assets/live.png', () async {
                    try {
                      final dio = ref.read(dioProvider);
                      final response = await dio.get('/live-videos');
                      if (response.statusCode == 200) {
                        ShareCard(
                          title: "live".tr(),
                          link: response.data['video_url'],
                        ).launchURL(context);
                      }
                    } catch (e) {
                      log(e.toString());
                    } finally {
                      EasyLoading.dismiss();
                    }
                  }),
                  _gridItem(context, 'epaper', 'assets/epaper.png', () {
                    ShareCard(
                      title: "epaper".tr(),
                      link: "https://epaper.sakshi.com/",
                    ).launchURL(context);
                  }),
                  _gridItem(context, 'poll', 'assets/poll.png', () {
                    ref.read(tabIndexProvider.notifier).state = 1;
                  }),
                  _gridItem(context, 'grievance', 'assets/grievance.png', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GrievanceTab()),
                    );
                  }),
                  _gridItem(context, 'important_pdfs',
                      'assets/important_documents.png', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ImportantDocsUi()),
                    );
                  }),
                  _gridItem(context, 'rewards', 'assets/rewards_icon.png', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RewardsScreen()),
                    );
                  }),
                  _gridItem(context, 'leaderboard', 'assets/leaderboard.png',
                      () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LeaderBoardUiTemp();
                    }));
                  }),
                  _gridItem(context, 'language_settings', 'assets/language.png',
                      () {}),
                  _gridItem(context, 'help', 'assets/help.png', () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => HelpScreen()),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 16),

              // Social icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialIcon('assets/facebook.png'),
                  _socialIcon('assets/instagram.png'),
                  _socialIcon('assets/twitter.png'),
                  _socialIcon('assets/youtube.png'),
                  _socialIcon('assets/threads.png'),
                ],
              ),

              const SizedBox(height: 35),

              // Share & Logout Buttons
              Row(
                children: [
                  Gap(30),
                  Expanded(
                    child: gradientButton(
                        gradient: LinearGradient(
                          colors: [Color(0xFFB8F6BE), Color(0xFF4BDF57)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("share".tr(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            Gap(5),
                            Icon(
                              FontAwesomeIcons.solidShareFromSquare,
                              size: 20,
                            )
                          ],
                        ),
                        onPressed: () {
                          // Handle share
                        },
                        borderRadius: 12),
                  ),
                  Gap(20),
                  Expanded(
                    child: gradientButton(
                      borderRadius: 12,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFB5F5F), Color(0xFFEFAD99)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("logout".tr(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          Gap(5),
                          Icon(
                            MdiIcons.logout,
                            size: 20,
                          )
                        ],
                      ),
                      onPressed: () async {
                        await LogoutInvalidationProvider.logout(ref, context);
                      },
                    ),
                  ),
                  Gap(30),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridItem(BuildContext context, String labelKey, String assetPath,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(assetPath, height: 40),
              ],
            ),
          ),
          Gap(12),
          Text(
            labelKey.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Image.asset(assetPath, height: 35, width: 35),
    );
  }
}

Widget gradientButton({
  required LinearGradient gradient,
  required Widget child,
  required VoidCallback onPressed,
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
  double borderRadius = 30,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black, // Optional border color
          width: 0.6, // Optional border width
        ),
      ),
      child: Center(child: child),
    ),
  );
}
