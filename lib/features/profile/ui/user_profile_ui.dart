import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/helper_class/logout_invalidate_providers.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/features/home_screen/widgets/multi_level_progress_widgets.dart';
import 'package:ysr_project/features/profile/provider/profileProvider.dart';
import 'package:ysr_project/features/profile/ui/profile_edit.dart';

class UserProfileUI extends ConsumerWidget {
  final String phoneNumber;
  const UserProfileUI(this.phoneNumber, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileAsyncProvider(phoneNumber));
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            "profile".tr(),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileEdit(
                                phoneNumber: phoneNumber,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit),
                      Gap(10),
                      Text(
                        "edit".tr(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ))
          ],
        ),
        body: profileData.when(
            data: (value) {
              final data = value;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    Initicon(
                      text: data.name,
                      size: 100,
                      backgroundColor: Colors.blueGrey,
                    ),

                    SizedBox(height: 20),
                    ref.watch(futurePointsProvider).when(
                          loading: () => Skeletonizer(
                            enabled: true,
                            child: MultiLevelProgressWidget(
                              progress: 100,
                              progressColor: Colors.grey,
                            ),
                          ),
                          data: (data) => ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            leading: Image.asset(
                              'assets/coin.png',
                              width: 25,
                              height: 25,
                            ),
                            title: Text("total_points".tr(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "level: ${(data.totalPoints! ~/ 100)}",
                                style: TextStyle()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "${data.totalPoints.toString()} / ${((data.totalPoints! ~/ 100) + 1) * 100}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                Gap(10),
                                CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 7.0,
                                  animation: true,
                                  animationDuration: 3000,
                                  percent: ((data.totalPoints! % 100) / 100)
                                      .clamp(0.0, 1.0),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: AppColors.primaryColor,
                                  backgroundColor: Colors.green.shade300,
                                )
                              ],
                            ),
                          ),
                          error: (_, __) => SizedBox.shrink(),
                        ),
                    SizedBox(height: 20),
                    // User Details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 170,
                            child: TextField(
                              readOnly: true, // Make it non-editable
                              controller: TextEditingController(
                                  text: data.referralCode),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                labelText: "referral_code".tr(),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              String link =
                                  "Check out this video: referral tv\nJoin our platform using my referral code${data.referralCode} and earn Signup bonus of 100 points and Referral Bonus of 50 points! Sign up here: https://drive.google.com/file/d/1lVrEEKee_4toRpCMYhPvrJdpakUpaVpm/view?usp=drive_link";
                              ShareCard(title: "referral tv", link: link)
                                  .shareOnSocialMedia(context, "whatsapp");
                            },
                            child: Chip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("share_on".tr()),
                                  Gap(10),
                                  Icon(
                                    MdiIcons.whatsapp,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              backgroundColor: Colors.green,
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (data.name.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.user,
                        title: "name".tr(),
                        value: data.name,
                      ),
                    ],
                    if (data.email.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.mail,
                        title: "email".tr(),
                        value: data.email,
                      ),
                    ],
                    if (data.mobile.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.phone,
                        title: "phone".tr(),
                        value: data.mobile,
                      ),
                    ],
                    if (data.country.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.globe,
                        title: "country".tr(),
                        value: data.country,
                      ),
                    ],

                    if (data.parliament.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.mapPin,
                        title: "parliament".tr(),
                        value: data.parliament,
                      ),
                    ],
                    if (data.constituency.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.mapPin,
                        title: "constituency".tr(),
                        value: data.constituency,
                      ),
                    ],
                    if (data.gender.isNotEmpty) ...[
                      ProfileCard(
                        icon: Icons.person,
                        title: "gender".tr(),
                        value: data.gender,
                      ),
                    ],

                    // Logout Button
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        await LogoutInvalidationProvider.logout(ref, context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("logout".tr(),
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              );
            },
            error: (error, stack) {
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => Center(
                  child: CircularProgressIndicator.adaptive(),
                )));
  }
}

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }
}
