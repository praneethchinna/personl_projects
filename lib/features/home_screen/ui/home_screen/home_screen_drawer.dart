import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/gallery/ui/gallary_ui.dart';
import 'package:ysr_project/features/home_screen/response_model/pdf_ui.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/girievance_tab.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_tab_screen.dart';
import 'package:ysr_project/features/home_screen/ui/influencer_video_ui.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/features/home_screen/ui/special_videos_page.dart';
import 'package:ysr_project/features/profile/ui/user_profile_ui.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

class HomeScreenDrawer extends ConsumerWidget {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(padding: EdgeInsets.zero, children: [
        // SizedBox(
        //   height: 270,
        //   child:
        //   DrawerHeader(
        //       decoration: BoxDecoration(color: AppColors.primaryColor),
        //       child: Column(
        //         children: [
        //           GestureDetector(
        //             onTap: () {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => UserProfileUI(
        //                           ref.read(userProvider).mobile)));
        //             },
        //             child: Initicon(
        //               text: ref.read(userProvider).name,
        //               size: 100,
        //             ),
        //           ),
        //           Gap(10),
        //           Text(
        //             ref.read(userProvider).name,
        //             style: TextStyle(color: Colors.white, fontSize: 20),
        //           ),
        //           Gap(5),
        //           Text(
        //             ref.read(userProvider).mobile,
        //             style: TextStyle(color: Colors.white, fontSize: 15),
        //           )
        //         ],
        //       )),
        // ),
        UserAccountsDrawerHeader(
          accountName: Text(
            ref.read(userProvider).name,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          accountEmail: Text(ref.read(userProvider).mobile),
          currentAccountPicture: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserProfileUI(ref.read(userProvider).mobile)));
            },
            child: Initicon(
              text: ref.read(userProvider).name,
              size: 100,
            ),
          ),
          decoration: BoxDecoration(color: AppColors.primaryColor),
        ),
        ListTile(
          leading: Icon(Icons.live_tv),
          title: Text("live".tr()),
          onTap: () async {
            try {
              final dio = ref.read(dioProvider);
              final response = await dio.get('/live-videos');
              if (response.statusCode == 200) {
                ShareCard(
                  title: "sakshi tv",
                  link: response.data['video_url'],
                ).launchURL(context);
              }
            } catch (e) {
              log(e.toString());
            } finally {
              EasyLoading.dismiss();
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text("epaper".tr()),
          onTap: () {
            ShareCard(
              title: "sakshi tv",
              link: "https://epaper.sakshi.com/",
            ).launchURL(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.bar_chart),
          title: Text("poll".tr()),
          onTap: () {
            ref.read(tabIndexProvider.notifier).state = 1;
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("home".tr()),
          onTap: () {
            ref.read(tabIndexProvider.notifier).state = 0;
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.photo),
          title: Text("gallery".tr()),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GalleryScreen(),
            ));
          },
        ),
        ListTile(
          leading: Icon(MdiIcons.youtube),
          title: Text("special_videos".tr()),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SpecialVideosPage(),
            ));
          },
        ),
        ListTile(
          leading: Icon(Icons.person_pin_outlined),
          title: Text("influencer_videos".tr()),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InfluencerVideoUI(),
            ));
          },
        ),
        ListTile(
          leading: Icon(Icons.picture_as_pdf),
          title: Text("important_pdfs".tr()),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PdfListWidget(),
            ));
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text("help".tr()),
          onTap: () {
            // Add your Help action
          },
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text("grievance".tr()),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const GrievanceTab(),
            ));
          },
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text("share".tr()),
          onTap: () {
            // Add share action
          },
        ),
      ]),
    );
  }
}
