import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ysr_project/colors/app_colors.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: MainNavigationPage(),
      ),
    ),
  );
}

final indexProvider = StateProvider<int>((ref) {
  return 0; // Default index for the BottomNavigationBar
});

class Widget1 extends ConsumerWidget {
  const Widget1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Home Screen')),
    );
  }
}

class Widget2 extends ConsumerWidget {
  const Widget2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Poll')),
      body: Center(child: Text('Poll Screen')),
    );
  }
}

class Widget3 extends ConsumerWidget {
  const Widget3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Special Videos')),
      body: Center(child: Text('Special Videos Screen')),
    );
  }
}

class Widget4 extends ConsumerWidget {
  const Widget4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('More')),
      body: Center(child: Text('More Screen')),
    );
  }
}

class MainNavigationPage extends ConsumerWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: IndexedStack(
          index: ref.watch(indexProvider),
          children: const [
            Widget1(),
            Widget2(),
            Widget3(),
            Widget4(),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            Container(
              height: 100,
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
              currentIndex: ref.watch(indexProvider),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.homeCircle), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.poll), label: 'poll'),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svgs/video_icon.svg',
                      color: ref.watch(indexProvider) == 2
                          ? AppColors.deepPurple
                          : Colors.black,
                      height: 20,
                    ),
                    label: 'Special Videos'),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svgs/more_icon.svg',
                      color: ref.watch(indexProvider) == 3
                          ? AppColors.deepPurple
                          : Colors.black,
                      height: 20,
                    ),
                    label: 'More'),
              ],
              onTap: (index) {
                ref.read(indexProvider.notifier).state = index;
              },
            ),
          ],
        ));
  }
}
