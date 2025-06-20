import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_notifier.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_notifier_temp.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_response_model.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_viewmodel.dart';
import 'package:ysr_project/features/leaderborad/utils/user_profile_card.dart';

class LeaderBoardUiTemp extends ConsumerStatefulWidget {
  const LeaderBoardUiTemp({super.key});

  @override
  _LeaderBoardUiTempState createState() => _LeaderBoardUiTempState();
}

class _LeaderBoardUiTempState extends ConsumerState<LeaderBoardUiTemp>
    with SingleTickerProviderStateMixin {
  _LeaderBoardUiTempState();
  late TabController _tabController;
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Types.values.length, vsync: this);
    _tabController.addListener(observeChanges);
  }

  void observeChanges() {
    if (!_tabController.indexIsChanging) {
      // This means the user has finished selecting a new tab.
      final index = _tabController.index;
      ref
          .read(leaderBoardNotifierProvider.notifier)
          .updateType(Types.values[index]);
      log("Tab changed to index: $index");
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(leaderBoardNotifierProvider);
    final notifier = ref.read(leaderBoardNotifierProvider.notifier);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: YsrAppBar(
          centerTitle: true,
          title: Text(
            "Leaderboard",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
              Gap(10),
              _buildCustomTabBar(context),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    stateAsync.when(
                        data: (data) {
                          return SingleChildScrollView(
                            child: buildColumn(
                                data, notifier, data.loggedUserRank),
                          );
                        },
                        error: (error, stackTrace) {
                          return Center(child: Text(error.toString()));
                        },
                        loading: () => Center(
                            child: CircularProgressIndicator.adaptive())),
                    stateAsync.when(
                        data: (data) {
                          return SingleChildScrollView(
                            child: buildColumn(
                                data, notifier, data.loggedUserRank),
                          );
                        },
                        error: (error, stackTrace) {
                          return Center(child: Text(error.toString()));
                        },
                        loading: () => Center(
                            child: CircularProgressIndicator.adaptive())),
                    stateAsync.when(
                        data: (data) {
                          return SingleChildScrollView(
                            child: buildColumn(
                                data, notifier, data.loggedUserRank),
                          );
                        },
                        error: (error, stackTrace) {
                          return Center(child: Text(error.toString()));
                        },
                        loading: () => Center(
                            child: CircularProgressIndicator.adaptive())),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget buildColumn(LeaderBoardState data, LeaderBoardNotifierTemp notifier,
      LeaderboardEntry userLevel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IntrinsicWidth(
              child: DropdownSearch<String>(
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: 'Select an item',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                ),
                items: (s, e) => data.names,
                selectedItem: data.selectedName,
                onChanged: (value) {
                  _selectedValue = value!;
                  log(_selectedValue);
                  Future.delayed(Duration(seconds: 1)).then((value) {
                    log(value.toString());
                    notifier.updateValue(_selectedValue);
                  });
                },
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  containerBuilder: (context, popupWidget) {
                    return Material(
                      elevation: 0,
                      color: Colors.white,
                      child: popupWidget,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Gap(10),
        _buildTopLevelUsers(data.topLevels),
        Gap(10),
        _buildLeadrBoardList(data.leaderBoards, notifier, userLevel)
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
      return Row(
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

  Widget _buildCustomTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (value) {},
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.blueAccent,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        automaticIndicatorColorAdjustment: true,
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: Types.values.map((type) {
          return Tab(
            text: type.description[0].toUpperCase() +
                type.description.substring(1),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeadrBoardList(LeaderBoards leaderBoards,
      LeaderBoardNotifierTemp notifier, LeaderboardEntry userLevel) {
    final data = leaderBoards.leaderBoards;
    return Column(
      children: [
        usersBoard(userLevel, isLoggedUser: true),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final user = data[index];
            return usersBoard(user);
          },
        ),
        if (leaderBoards.hasNext)
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
              )),
        Gap(10)
      ],
    );
  }

  Container usersBoard(LeaderboardEntry user, {bool isLoggedUser = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isLoggedUser ? AppColors.lightSkyBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading section: Rank + Profile Image
          Row(
            children: [
              Text(
                user.rank.toString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
              isLoggedUser
                  ? Initicon(text: user.name, size: 34)
                  : Image.asset(
                      'assets/profile.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
            ],
          ),
          Gap(20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2),
              Text(
                user.userLevel,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(),
          ),
          Text(
            "${user.totalPoints} Points",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
