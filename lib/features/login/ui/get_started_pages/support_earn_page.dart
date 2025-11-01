import 'package:flutter/material.dart';
import 'package:ysr_project/features/login/ui/initial_screens.dart';
import 'package:ysr_project/features/login/ui/login_screen.dart';

class SupportEarnPage extends StatelessWidget {
  const SupportEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InitialScreen(
      title1: "Support. \nEarn. \nRaise.",
      title2:
          '''Your actions earn you rewards. \nLikes, shares, polls every click \ncounts.''',
      image: "assets/initial_screens/support_earn.png",
      buttonTitle: "Start Your Journey",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
    );
  }
}
