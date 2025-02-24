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
import 'package:ysr_project/features/home_screen/widgets/multi_level_progress_widgets.dart';
import 'package:ysr_project/features/profile/provider/profileProvider.dart';

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
            "Profile",
          ),
          centerTitle: true,
        ),
        body: profileData.when(
            data: (value) {
              final data = value.user!;
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
                            title: Text("Total Points",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "Level: ${(data.totalPoints! ~/ 100)}",
                                style: TextStyle()),
                            trailing: Row(

                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${data.totalPoints.toString()} / ${((data.totalPoints! ~/ 100)+1) * 100}",
                                    style:
                                        TextStyle(color: Colors.black,
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
                    SizedBox(height: 10),
                    // User Details
                    if (data.name.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.user,
                        title: "Name",
                        value: data.name,
                      ),
                    ],
                    if (data.email.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.mail,
                        title: "Email",
                        value: data.email,
                      ),
                    ],
                    if (data.mobile.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.phone,
                        title: "Phone",
                        value: data.mobile,
                      ),
                    ],
                    if (data.role.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.briefcase,
                        title: "Role",
                        value: data.role,
                      ),
                    ],
                    if (data.parliament.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.mapPin,
                        title: "Parliament",
                        value: data.parliament,
                      ),
                    ],
                    if (data.constituency.isNotEmpty) ...[
                      ProfileCard(
                        icon: LucideIcons.mapPin,
                        title: "Constituency",
                        value: data.constituency,
                      ),
                    ],
                    if (data.gender.isNotEmpty) ...[
                      ProfileCard(
                        icon: Icons.person,
                        title: "Gender",
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
                      child: Text("Logout",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
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
