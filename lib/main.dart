import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gif_view/gif_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/ui/home_tab_screen.dart';
import 'package:ysr_project/features/login/ui/login_screen.dart';
import 'package:ysr_project/services/user/user_data.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.grey.shade200, // Background color for Scaffold
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF0066B3), // Primary color
          primary: Color(0xFF0066B3), // Primary color
          secondary: Color(0xFF00904C), // Secondary color
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0066B3), // AppBar color
        ),
      ),
      builder: EasyLoading.init(),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  final GifController controller = GifController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.play();
      // Stop 2 frames before the end using a timer
      timer = Timer(const Duration(milliseconds: 1000), () async {
        controller.pause();
        await Future.delayed(Duration(seconds: 2));
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String? userData = prefs.getString("userData");

        if (userData != null) {
          final userRealData = jsonDecode(userData);
          ref.read(userProvider.notifier).update(
                (state) => User(
                  message: userRealData['message'],
                  userId: userRealData['user_id'],
                  name: userRealData['name'],
                  role: userRealData['role'],
                  mobile: userRealData['mobile'],
                  parliament: userRealData['parliament'],
                  constituency: userRealData['constituency'],
                ),
              );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeTabScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mySoftPearl,
      child: GifView.asset(
        'assets/speech (1).gif',
        height: 200,
        width: 200,
        frameRate: 30,
        controller: controller,
        loop: false,
      ),
    );
  }
}
