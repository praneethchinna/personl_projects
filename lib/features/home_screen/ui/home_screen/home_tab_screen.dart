import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_feed_screen.dart';
import 'package:ysr_project/features/home_screen/ui/influencer_video_ui.dart';
import 'package:ysr_project/features/home_screen/ui/more_screen.dart';
import 'package:ysr_project/features/polls/ui/poll_screen.dart';
import 'package:ysr_project/features/special_videos/special_videos_ui.dart';

class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({super.key});
  @override
  ConsumerState<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends ConsumerState<HomeTabScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeFeedScreen(),
    PollScreen(),
    SpecialVideosUi(),
    MoreScreen(),
    InfluencerVideoUI(
      showAppBar: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    _selectedIndex = ref.watch(tabIndexProvider);
    return WillPopScope(
      onWillPop: () async {
        if (ref.watch(tabIndexProvider) != 0) {
          ref.read(tabIndexProvider.notifier).update((state) => 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: null,
        // appBar: AppBar(
        //   foregroundColor: Colors.white,
        //   iconTheme: IconThemeData(color: Colors.white),
        //   titleSpacing: 0,
        //   title: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Image.asset(
        //         'assets/image_2.png',
        //         width: 60,
        //         height: 60,
        //         fit: BoxFit.contain,
        //       ),
        //       Gap(50),
        //       Expanded(
        //         child: Text(
        //           "Hi..  ${ref.read(userProvider).name}",
        //           style: TextStyle(fontSize: 18),
        //         ),
        //       ),
        //       Gap(5),
        //     ],
        //   ),
        //   actions: [
        //     Consumer(
        //       builder: (context, ref, _) {
        //         final userName = ref.watch(languageProvider);
        //         return EasyToggleButton(
        //           initialValue: userName.languageCode == "en",
        //           changed: (value) {
        //             Locale newLocale = value ? Locale('en') : Locale('te');
        //
        //             ref.read(languageProvider.notifier).state = newLocale;
        //
        //             context.setLocale(newLocale);
        //             LanguageSettings.updateLanguage(newLocale.languageCode);
        //           },
        //         );
        //       },
        //     ),
        //     Gap(3),
        //     GestureDetector(
        //       onTap: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => NotificationImp()));
        //       },
        //       child: Icon(
        //         Icons.notifications_active,
        //       ),
        //     ),
        //     SizedBox(
        //       width: 10,
        //     ),
        //   ],
        // ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Stack(
          children: [
            Container(
              height: Platform.isIOS ? 100 : 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.skyBlue,
                    AppColors.pastelGreen,
                  ],
                ),
              ),
            ),
            BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.black,
              unselectedLabelStyle: TextStyle(color: Colors.black),
              showUnselectedLabels: true,
              selectedItemColor: AppColors.deepPurple,
              currentIndex: ref.watch(tabIndexProvider),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.homeCircle), label: 'home'.tr()),
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.poll), label: 'poll'.tr()),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svgs/video_icon.svg',
                      color: ref.watch(tabIndexProvider) == 2
                          ? AppColors.deepPurple
                          : Colors.black,
                      height: 20,
                    ),
                    label: 'special_videos'.tr()),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svgs/more_icon.svg',
                      color: ref.watch(tabIndexProvider) == 3
                          ? AppColors.deepPurple
                          : Colors.black,
                      height: 20,
                    ),
                    label: 'more'.tr()),
              ],
              onTap: (index) {
                ref.read(tabIndexProvider.notifier).state = index;
              },
            ),
          ],
        ),
      ),
    );
  }
}

final tabIndexProvider = StateProvider<int>((ref) => 0);
