import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/widgets/grievance_widget.dart';
import 'package:ysr_project/services/user/user_data.dart';

class GrievanceList extends ConsumerWidget {
  const GrievanceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGrievances = ref.watch(futureGrievancesProvider);

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: asyncGrievances.when(
        data: (data) {
          final filteredData = data.where((element) {
            return element.userId == ref.read(userProvider).userId;
          }).toList();
          if (filteredData.isEmpty) {
            return Center(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/empty_ui.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ));
          }
          return SingleChildScrollView(
            child: Column(
              children: filteredData
                  .map((grievance) => GrievanceWidget(
                        grievance: grievance,
                      ))
                  .toList(),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
              child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/empty_ui.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ));
        },
        loading: () {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const ShimmerLoadingWidget();
            },
          );
        },
      ),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
