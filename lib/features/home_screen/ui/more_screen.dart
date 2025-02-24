import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/gallery/ui/gallary_ui.dart';
import 'package:ysr_project/features/home_screen/helper_class/logout_invalidate_providers.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              try {
                final dio = ref.read(dioProvider);
                final response = await dio.get('/live-videos');
                if (response.statusCode == 200) {
                  ShareCard(
                          title: "sakshi tv", link: response.data['video_url'])
                      .launchURL(context);
                }
              } catch (e) {
                log(e.toString());
              } finally {
                EasyLoading.dismiss();
              }
            },
            child: _buildMenuItem(Icons.live_tv, "Live", Colors.red),
          ),
          GestureDetector(
              onTap: () async {
                ShareCard(
                        title: "sakshi tv", link: "https://epaper.sakshi.com/")
                    .launchURL(context);
              },
              child: _buildMenuItem(Icons.description, "E-Paper", Colors.blue)),
          InkWell(
              onTap: () {
                ref.read(tabIndexProvider.notifier).state = 1;
              },
              child: _buildMenuItem(Icons.bar_chart, "Poll", Colors.green)),
          GestureDetector(
              onTap: () {
                ref.read(tabIndexProvider.notifier).state = 0;
              },
              child: _buildMenuItem(Icons.home, "Home", Colors.blue)),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GalleryScreen(),
                ));
              },
              child: _buildMenuItem(Icons.photo, "Gallery", Colors.purple)),
          _buildMenuItem(Icons.help, "Help", Colors.orange),
          _buildMenuItem(Icons.people, "Grievance", Colors.brown),
          _buildMenuItem(Icons.share, "Share", Colors.blueGrey),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color.fromARGB(255, 195, 21, 8),
              ),
              onPressed: () async {
                await LogoutInvalidationProvider.logout(ref, context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Logout", style: TextStyle(color: Colors.white)),
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

final tabIndexProvider = StateProvider<int>((ref) {
  return 0;
});
