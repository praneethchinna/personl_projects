import 'package:flutter/material.dart';
import 'package:ysr_project/features/login/ui/get_started_pages/true_stories_page.dart';
import 'package:ysr_project/features/login/ui/initial_screens.dart';

class YourVoicePage extends StatelessWidget {
  const YourVoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return InitialScreen(
      title1: "Your Voice. \nOur Strength",
      title2:
          '''When people speak. \nLeadership listens.  \nBe the voice of We YSRCP''',
      image: "assets/initial_screens/you_voice.png",
      buttonTitle: "Get Started",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TrueStoriesPage(),
          ),
        );
      },
    );
  }
}
