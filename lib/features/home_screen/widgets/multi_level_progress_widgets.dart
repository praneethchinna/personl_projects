import 'package:flutter/material.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/widgets/multi_level_circular_indicator.dart';

class MultiLevelProgressWidget extends StatelessWidget {
  final Color? progressColor;
  final double progress; // Current progress

  const MultiLevelProgressWidget(
      {super.key, required this.progress, this.progressColor});

  @override
  Widget build(BuildContext context) {
    double levelGap = 100; // Each level covers 100 points
    int currentLevel = (progress ~/ levelGap); // Determine the current level
    int nextLevel = currentLevel + 1; // Determine the next level
    double progressPercentage =
        (progress % levelGap) / levelGap; // Progress within current level

    return GestureDetector(
      onTap: () async {
        await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (b) {
              return FractionallySizedBox(
                heightFactor: 0.3,
                child: MultiLevelCircularProgressWidget(
                  progress: progress,
                  progressColor: progressColor,
                ),
              );
            });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
        decoration: BoxDecoration(
          color: progressColor != null ? progressColor : Colors.green.shade500,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text(
                "Your Progress",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${progress.toInt()} / ${nextLevel * levelGap}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 8),

            // Progress Bar
            LayoutBuilder(
              builder: (context, constraints) {
                double barWidth = constraints.maxWidth * progressPercentage;

                return Stack(
                  children: [
                    // Background Bar
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Filled Progress
                    Container(
                      height: 12,
                      width: barWidth,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blue,
                            AppColors.primaryColor
                          ], // Progress color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 8),

            // Level Labels (Show only current and next level)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Level $currentLevel",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                Text(
                  "Level $nextLevel",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
