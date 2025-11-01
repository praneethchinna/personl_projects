import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/myrewards/ui/widgets/badge_card.dart';
import 'package:ysr_project/features/myrewards/ui/widgets/level_unlock_dialog.dart';
import '../provider/rewards_provider.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardsAsync = ref.watch(rewardsFutureProvider);

    return Scaffold(
      backgroundColor: AppColors.lightMoss,
      appBar: YsrAppBar(
        title: const Text('My Rewards'),
        centerTitle: true,
        elevation: 0,
      ),
      body: rewardsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (rewardsData) {
          return Column(
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/profile.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              Gap(10),
              Text(
                rewardsData.name.split(" ").map((word) {
                  if (word.isEmpty) return word;
                  return word[0].toUpperCase() +
                      word.substring(1).toLowerCase();
                }).join(" "),
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
              SizedBox(height: 4),
              Text(rewardsData.currentLevel.toString(),
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
                      rewardsData.totalPoints.toString(),
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
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/rewards/level_tag.png",
                            width: 100, height: 100),
                        GridView.builder(
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: rewardsData.levels.length,
                          itemBuilder: (context, index) {
                            final level = rewardsData.levels[index];
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => LevelUnlockDialog(
                                        userPoints: rewardsData.totalPoints,
                                        endPointRange: level.endPointRange,
                                        isUnlocked: level.completed,
                                        level: level.level,
                                        rewardText: level.incentives,
                                        rewardImagePath: !level.completed
                                            ? "assets/gif/box_closed.gif"
                                            : "assets/gif/box_opened.gif",
                                        lockIconPath: level.completed
                                            ? "assets/rewards/unlock_icon.png"
                                            : "assets/rewards/lock_icon.png"));
                              },
                              child: BadgeCard(
                                  isUnlocked: level.completed,
                                  level: level.level,
                                  badgeName: level.incentives,
                                  badgeType: level.incentives,
                                  badgeImage: AssetImage(
                                      'assets/rewards/medal_icon.png'),
                                  lockIconImage: level.completed
                                      ? AssetImage(
                                          'assets/rewards/unlock_icon.png')
                                      : AssetImage(
                                          'assets/rewards/lock_icon.png')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
