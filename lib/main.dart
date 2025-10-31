import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_tab_screen.dart';
import 'package:ysr_project/features/login/ui/get_started_pages/your_voice_page.dart';

import 'package:ysr_project/services/shared_preferences/shared_preferences_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

List<CameraDescription> cameras = [];
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
   MediaKit.ensureInitialized( );
  await EasyLocalization.ensureInitialized();

  cameras = await availableCameras();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }
  final language = await LanguageSettings.getLanguage();
  runApp(ProviderScope(
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('te')],
      path: 'assets/translations',
      fallbackLocale: Locale(language),
      child: MyApp(),
    ),
  ));

  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = AppColors.primaryColor.withOpacity(0.2)
    ..displayDuration = const Duration(seconds: 2)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 36.0
    ..radius = 100.0
    ..contentPadding = EdgeInsets.zero
    ..progressColor = Colors.black
    ..backgroundColor = Colors.white
    ..indicatorColor = AppColors.electricOcean
    ..textColor = Colors.black
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
        await updateLanguageProvider();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeTabScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => YourVoicePage()),
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
          child: Image.asset("assets/gif/ysr_splash_gif.gif",
              width: 700, height: 700),
        ),
      ),
    );
  }

  Future<void> updateLanguageProvider() async {
    final language = await LanguageSettings.getLanguage();
    ref.read(languageProvider.notifier).update((state) => Locale(language));
  }
}

final languageProvider = StateProvider<Locale>((ref) {
  return Locale("en");
});
