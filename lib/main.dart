import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ysr_project/features/home_screen/ui/home_tab_screen.dart';
import 'package:ysr_project/features/login/ui/login_screen.dart';
import 'package:ysr_project/services/user/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }

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
  late AnimationController _animationController;

  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Create scale animation
    //use elasticout for better effect
    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to the main screen after animation completes
    Future.delayed(const Duration(seconds: 4), () async {
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            'assets/ysr.png',
            width: 700,
            height: 700,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
