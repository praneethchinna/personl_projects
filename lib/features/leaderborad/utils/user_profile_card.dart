import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:gap/gap.dart'; // Import the gap package

class UserProfileCard extends StatelessWidget {
  final String userName;
  final String currentLevel;
  final int currentPoints;
  final double progressPercentage; // Value between 0.0 and 1.0
  final Color? progressColor; // Optional custom color for the progress bar

  const UserProfileCard({
    super.key,
    required this.userName,
    required this.currentLevel,
    required this.currentPoints,
    required this.progressPercentage,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // Adjusted padding for better visual
      decoration: BoxDecoration(
        color:
            const Color(0xFFE0F2F7), // Light blue background color from image
        borderRadius:
            BorderRadius.circular(16), // Slightly more rounded corners
        boxShadow: [
          // Optional: Add a subtle shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          ClipOval(
            // Clip the image to a circle
            child: Initicon(text: userName, size: 50),

            //
            // Image.asset(
            //   'assets/profile.png', // Ensure this path is correct
            //   width: 44, // Larger image for prominence
            //   height: 44,
            //   fit: BoxFit.cover,
            // ),
          ),
          const Gap(16), // Increased gap for better spacing

          // User Info and Progress Bar
          Expanded(
            // Use Expanded to allow the Column to take available width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Keep column size minimal
              children: [
                // User Name
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 12, // Slightly larger font for name
                    fontWeight: FontWeight.w600,
                    color: Colors.black87, // Darker text for readability
                  ),
                ),
                const Gap(4), // Small gap between name and level

                // Level and Points
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentLevel,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w400, // Slightly bolder for level
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "$currentPoints Points",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Gap(10), // Gap before the progress bar

                // Custom Linear Progress Indicator
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Ensure progressPercentage is clamped between 0 and 1
                    final clampedProgress = progressPercentage.clamp(0.0, 1.0);
                    double barWidth = constraints.maxWidth * clampedProgress;

                    return Stack(
                      children: [
                        // Background Bar
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white, // White background for the bar
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        // Filled Progress
                        Container(
                          height: 12,
                          width: barWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                progressColor ??
                                    Colors.green.shade300, // Light green
                                progressColor ??
                                    Colors.green.shade500, // Darker green
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
