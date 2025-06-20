import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
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
        backgroundColor: Colors.white,
        appBar: YsrAppBar(
          title: Text(
            "profile".tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  child: Icon(MdiIcons.accountEdit),
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
                    Column(
                      children: [
                        Image.asset(
                          'assets/profile.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        Gap(10),
                        Text(
                          data.name,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Image.asset(
                          'assets/level.png',
                          width: 38,
                          height: 38,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    ref.watch(futurePointsProvider).when(
                          loading: () => Skeletonizer(
                            enabled: true,
                            child: MultiLevelProgressWidget(
                              progress: 100,
                              progressColor: Colors.grey,
                            ),
                          ),
                          data: (data) => Column(
                            children: [
                              Text(data.userLevel.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/points.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    Gap(10),
                                    Text(
                                      data.totalPoints.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    Gap(5),
                                    Text(
                                      "points".tr(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  LikeStatCard(
                                    label: "liked".tr(),
                                    count: data.likedCount ?? 0,
                                    imagePath: 'assets/liked_icon.png',
                                  ),
                                  LikeStatCard(
                                    label: "commented".tr(),
                                    count: data.commentedCount ?? 0,
                                    imagePath: 'assets/commented_icon.png',
                                  ),
                                  LikeStatCard(
                                    label: "shared".tr(),
                                    count: data.sharedCount ?? 0,
                                    imagePath: 'assets/shared_icon.png',
                                  ),
                                ],
                              ),
                              Gap(15),
                              profileData.when(
                                data: (data) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            width: 200,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.deepPurple,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5)),
                                            ),
                                            child: Text(
                                              data.referralCode,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: data.referralCode));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Copied to clipboard")),
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                "COPY",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(5),
                                    ],
                                  );
                                },
                                error: (_, __) => SizedBox.shrink(),
                                loading: () => SizedBox.shrink(),
                              ),
                            ],
                          ),
                          error: (_, __) => SizedBox.shrink(),
                        ),

                    if (data.mobile.isNotEmpty) ...[
                      ProfileCard(
                        imagePath: 'assets/number_icon.png',
                        title: "phone".tr(),
                        value: data.mobile,
                      ),
                    ],
                    if (data.email.isNotEmpty) ...[
                      ProfileCard(
                        imagePath: 'assets/email_icon.png',
                        title: "email".tr(),
                        value: data.email,
                      ),
                    ],
                    if (data.gender.isNotEmpty) ...[
                      ProfileCard(
                        imagePath: 'assets/gender.png',
                        title: "gender".tr(),
                        value: data.gender,
                      ),
                    ],
                    if (data.country.isNotEmpty) ...[
                      ProfileCard(
                        imagePath: 'assets/country_icon.png',
                        title: "country".tr(),
                        value: data.country,
                      ),
                    ],
                    if (data.parliament.isNotEmpty) ...[
                      ProfileCard(
                        imagePath: 'assets/parliament_icon.png',
                        title: "parliament".tr(),
                        value: data.parliament,
                      ),
                    ],
                    if (data.constituency.isNotEmpty) ...[
                      ProfileCard(
                        imagePath: 'assets/assembly_icon.png',
                        title: "constituency".tr(),
                        value: data.constituency,
                      ),
                    ],
                    Gap(10),
                    // profileData.when(
                    //   data: (data) {
                    //     return Container(
                    //       height: 100,
                    //       margin: EdgeInsets.symmetric(horizontal: 10),
                    //       width: double.infinity,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.royalBlue,
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Row(
                    //               mainAxisSize: MainAxisSize.min,
                    //               children: [
                    //                 Container(
                    //                   padding: const EdgeInsets.all(10),
                    //                   alignment: Alignment.center,
                    //                   width: 200,
                    //                   height: 40,
                    //                   decoration: BoxDecoration(
                    //                     color: AppColors.deepPurple,
                    //                     borderRadius: BorderRadius.only(
                    //                         topLeft: Radius.circular(5),
                    //                         bottomLeft: Radius.circular(5)),
                    //                   ),
                    //                   child: Text(
                    //                     data.referralCode,
                    //                     style: TextStyle(
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: Colors.white,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 GestureDetector(
                    //                   onTap: () {
                    //                     String link =
                    //                         "referral tv\nJoin our platform using my referral code${data.referralCode} and earn Signup bonus of 100 points and Referral Bonus of 50 points! Sign up here: https://drive.google.com/file/d/1lVrEEKee_4toRpCMYhPvrJdpakUpaVpm/view?usp=drive_link";
                    //                     ShareCard(title: "referral", link: link)
                    //                         .shareOnSocialMedia(
                    //                             context, "whatsapp");
                    //                   },
                    //                   child: Container(
                    //                     height: 40,
                    //                     padding: const EdgeInsets.all(10),
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.white,
                    //                       borderRadius: BorderRadius.only(
                    //                           topRight: Radius.circular(5),
                    //                           bottomRight: Radius.circular(5)),
                    //                       border: Border.all(
                    //                         color: AppColors.primaryColor,
                    //                         width: 1,
                    //                       ),
                    //                     ),
                    //                     child: Text(
                    //                       "COPY",
                    //                       style: TextStyle(
                    //                           fontSize: 12,
                    //                           fontWeight: FontWeight.w600,
                    //                           color: AppColors.primaryColor),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             Gap(10),
                    //             Text(
                    //               "Tap to copy your referral code",
                    //               style: TextStyle(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: Colors.white,
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   error: (_, __) => SizedBox.shrink(),
                    //   loading: () => SizedBox.shrink(),
                    // ),
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
  final String imagePath; // Path to asset image
  final String title;
  final String value;
  final double imageSize;

  const ProfileCard(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.value,
      this.imageSize = 25,
      th});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LikeStatCard extends StatelessWidget {
  final String label;
  final int count;
  final String imagePath; // PNG or asset path
  final Color? bgColor;
  final Color? iconColor;

  const LikeStatCard({
    super.key,
    required this.label,
    required this.count,
    required this.imagePath,
    this.bgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon (PNG image)
          Image.asset(
            imagePath,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 8),
          // Text content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
