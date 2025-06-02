import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_feed_screen.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_screen_drawer.dart';
import 'package:ysr_project/features/home_screen/ui/influencer_video_ui.dart';
import 'package:ysr_project/features/home_screen/ui/more_screen.dart';
import 'package:ysr_project/features/home_screen/ui/notification_imp.dart';
import 'package:ysr_project/features/home_screen/ui/special_videos_page.dart';
import 'package:ysr_project/features/home_screen/widgets/easy_toggle_button.dart';
import 'package:ysr_project/features/polls/ui/poll_screen.dart';
import 'package:ysr_project/services/shared_preferences/shared_preferences_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';
import 'package:ysr_project/main.dart';

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
    SpecialVideosPage(
      showAppBar: false,
    ),
    InfluencerVideoUI(
      showAppBar: false,
    ),
    MoreScreen(),
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
        drawer: HomeScreenDrawer(),
        appBar: AppBar(
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          titleSpacing: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/image_2.png',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              Gap(50),
              Expanded(
                child: Text(
                  "Hi..  ${ref.read(userProvider).name}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Gap(5),
            ],
          ),
          actions: [
            Consumer(
              builder: (context, ref, _) {
                final userName = ref.watch(languageProvider);
                return EasyToggleButton(
                  initialValue: userName.languageCode == "en",
                  changed: (value) {
                    Locale newLocale = value ? Locale('en') : Locale('te');

                    ref.read(languageProvider.notifier).state = newLocale;

                    context.setLocale(newLocale);
                    LanguageSettings.updateLanguage(newLocale.languageCode);
                  },
                );
              },
            ),
            Gap(3),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NotificationImp()));
              },
              child: Icon(
                Icons.notifications_active,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            ref.read(tabIndexProvider.notifier).state = value;
          },
          currentIndex: _selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.poll),
              label: 'poll'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_rounded),
              label: 'special_videos'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'influencer_videos'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_vert_rounded),
              label: 'more'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
