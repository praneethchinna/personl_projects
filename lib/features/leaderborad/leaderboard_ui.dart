import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/widgets/multi_level_progress_widgets.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_notifier_temp.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_providers.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_response_model.dart';
import 'package:ysr_project/features/leaderborad/utils/segmented_toggle.dart';
import 'package:ysr_project/features/leaderborad/utils/user_profile_card.dart';

class LeaderBoard extends ConsumerStatefulWidget {
  const LeaderBoard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends ConsumerState<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(leaderBoardProvider.notifier);
    final leaderboardData = ref.watch(leaderBoardProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: YsrAppBar(
          centerTitle: true,
          title: Text(
            'Leaderboard',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              ref.watch(futurePointsProvider).when(
                    loading: () => Skeletonizer(
                      enabled: true,
                      child: UserProfileCard(
                          userName: "data.userName!",
                          currentLevel: "data.userLevel?",
                          currentPoints: 34,
                          progressPercentage: 0.3),
                    ),
                    data: (data) {
                      final progress = data.totalPoints!.toDouble();
                      double levelGap = 100; // Each level covers 100 points

                      double progressPercentage =
                          (progress % levelGap) / levelGap;

                      return UserProfileCard(
                          userName: data.userName!,
                          currentLevel: data.userLevel?.toString() ?? 'Level 0',
                          currentPoints: data.totalPoints ?? 0,
                          progressPercentage: progressPercentage);
                    },
                    error: (_, __) => SizedBox.shrink(),
                  ),
              ref.watch(leaderBoardNotifierProvider).when(data: (data) {
                return _buildTopLevelUsers(data.topLevels);
              }, error: (e, s) {
                return Center(
                  child: Text(
                    'Error: $e',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }, loading: () {
                return Center(child: CircularProgressIndicator.adaptive());
              }),
              Expanded(
                child: Column(
                  children: [
                    Gap(20),
                    SegmentedToggle(onSelectionChanged: (value) {
                      notifier.updateType(value);
                    }),
                    Gap(20),
                    Expanded(
                      child: leaderboardData.when(
                        data: (data) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final user = data[index];
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 5),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            blurRadius: 8,
                                            offset:
                                                Offset(0, 4), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Leading section: Rank + Profile Image
                                          Row(
                                            children: [
                                              Text(
                                                user.rank.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(width: 10),
                                              Image.asset(
                                                'assets/profile.png',
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.contain,
                                              ),
                                            ],
                                          ),
                                          Gap(20),

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                user.name,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                user.userLevel,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: SizedBox(),
                                          ),
                                          Text(
                                            "${user.totalPoints} Points",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Gap(10),
                                ElevatedButton(
                                    onPressed: () {
                                      notifier.loadMore();
                                    },
                                    child: Text(
                                      "Load More....",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ))
                              ],
                            ),
                          );
                        },
                        error: (e, s) {
                          return Center(
                            child: Text(
                              'Error: $e',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                        loading: () {
                          return Center(
                              child: CircularProgressIndicator.adaptive());
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildTopLevelUsers(List<LeaderboardEntry> data) {
    if (data.isEmpty) {
      return SizedBox.shrink();
    } else if (data.length == 1) {
      return Center(
        child: buildCrownLevels(
            path: 'assets/crown_1.png',
            title: data[0].name,
            subtitle: data[0].totalPoints.toString()),
      );
    } else if (data.length == 2) {
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildCrownLevels(
              path: 'assets/crown_1.png',
              title: data[0].name,
              subtitle: data[0].totalPoints.toString()),
          buildCrownLevels(
              path: 'assets/crown_2.png',
              title: data[1].name,
              subtitle: data[1].totalPoints.toString()),
        ],
      );
    }
    return Column(
      children: [
        buildCrownLevels(
            path: 'assets/crown_1.png',
            title: data[0].name,
            subtitle: data[0].totalPoints.toString()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildCrownLevels(
                path: 'assets/crown_2.png',
                title: data[1].name,
                subtitle: data[1].totalPoints.toString()),
            buildCrownLevels(
                path: 'assets/crown_3.png',
                title: data[2].name,
                subtitle: data[2].totalPoints.toString()),
          ],
        )
      ],
    );
  }

  Widget buildCrownLevels(
      {required String path, required String title, required String subtitle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          path,
          width: 66,
          height: 66,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
