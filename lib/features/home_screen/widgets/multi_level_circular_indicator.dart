import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MultiLevelCircularProgressWidget extends StatelessWidget {
  final Color? progressColor;
  final double progress;

  const MultiLevelCircularProgressWidget({super.key, required this.progress, this.progressColor});

  @override
  Widget build(BuildContext context) {
    double levelGap = 100;
    int currentLevel = (progress ~/ levelGap);
    int nextLevel = currentLevel + 1;
    double progressPercentage = (progress % levelGap) / levelGap;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Progress Tracker",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 12.0,
            animation: true,
            animationDuration: 1200,
            percent: progressPercentage.clamp(0.0, 1.0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${progress.toInt()} pts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black87),
                ),
                Text(
                  "of ${nextLevel * levelGap}",
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: progressColor ?? Colors.blue,
            backgroundColor: Colors.grey.shade300,
            footer: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "Level $currentLevel → Level $nextLevel",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
