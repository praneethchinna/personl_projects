import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/ui/home_feed_screen.dart';
import 'package:ysr_project/features/home_screen/ui/more_screen.dart';
import 'package:ysr_project/features/home_screen/ui/notification_imp.dart';
import 'package:ysr_project/features/polls/ui/poll_screen.dart';
import 'package:ysr_project/features/profile/ui/user_profile_ui.dart';
import 'package:ysr_project/services/user/user_data.dart';

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
    MoreScreen(),
  ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index; // Change the selected index
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = ref.watch(tabIndexProvider);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/image_2.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationImp()));
            },
            child: Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.question_mark_sharp,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserProfileUI(ref.read(userProvider).mobile)));
            },
            child: Initicon(
              text: ref.read(userProvider).name,
              size: 35,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          ref.read(tabIndexProvider.notifier).state = value;
        },
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            label: 'Poll',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
