import 'package:flutter/material.dart';
import 'package:ysr_project/features/login/ui/get_started_pages/support_earn_page.dart';
import 'package:ysr_project/features/login/ui/initial_screens.dart';

class TrueStoriesPage extends StatelessWidget {
  const TrueStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InitialScreen(
      title1: "True Stories. \nReal Change",
      title2: '''Skip the noise.
Get facts, actions, and \nvictories direct from We YSRCP''',
      image: "assets/initial_screens/your_stories.png",
      buttonTitle: "Explore the Truth",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SupportEarnPage()),
        );
      },
    );
  }
}
