import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/grievance_list.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/grievance_ui.dart';
import 'package:ysr_project/main.dart';

final grievanceFormTabController = StateProvider.autoDispose<int>((ref) => 0);

class GrievanceTab extends ConsumerStatefulWidget {
  const GrievanceTab({super.key});

  @override
  ConsumerState<GrievanceTab> createState() => _GrievanceTabState();
}

class _GrievanceTabState extends ConsumerState<GrievanceTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(grievanceFormTabController);
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: initialTab);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        ref.read(grievanceFormTabController.notifier).state =
            _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(grievanceFormTabController);

    // Update tabController if the state changed externally
    if (_tabController.index != selectedTab) {
      _tabController.animateTo(selectedTab);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref.read(grievanceFormTabController.notifier).state = 1;
            },
            icon: const Icon(Icons.refresh),
          )
        ],
        foregroundColor: Colors.white,
        title: Text(
          "grievance_form".tr(),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.secondaryColor,
              tabs: [
                Tab(text: 'fill_grievance_form'.tr()),
                Tab(text: 'check_grievance'.tr()),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GrievanceFormStepper(cameras: cameras),
                GrievanceList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
