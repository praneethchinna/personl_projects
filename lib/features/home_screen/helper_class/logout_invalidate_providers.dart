import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/features/login/ui/login_screen.dart';
import 'package:ysr_project/features/polls/providers/polls_provider.dart';
import 'package:ysr_project/services/google_sign_in/google_sign_in_helper.dart';
import 'package:ysr_project/services/shared_preferences/shared_preferences_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

class LogoutInvalidationProvider {
  static Future<void> logout(WidgetRef ref, BuildContext context) async {
    {
      ref.invalidate(homeFeedNotifierProvider);
      ref.invalidate(pollsProvider);
      ref.invalidate(userProvider);
      ref.invalidate(futurePointsProvider);
      ref.invalidate(homeFeedNotifierProvider);
      ref.invalidate(futureNotificatonProvider);

      final prefs = await ref.read(sharedPreferencesProvider.future);
      prefs.clear();
      signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
    }
  }
}
