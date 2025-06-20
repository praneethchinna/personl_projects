import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BadgeCard extends StatelessWidget {
  final String level;
  final String badgeName;
  final String badgeType;
  final ImageProvider badgeImage;
  final ImageProvider lockIconImage;
  final bool isUnlocked;

  const BadgeCard({
    super.key,
    required this.level,
    required this.badgeName,
    required this.badgeType,
    required this.badgeImage,
    required this.lockIconImage,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: isUnlocked
          ? buildStack()
          : Stack(
              children: [
                Blur(child: buildStack()),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: -0.4712389, // -27 degrees in radians
                        child: Image(
                          image: lockIconImage,
                          width: 35,
                          height: 35,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        level,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),Gap(5),
                      Text(
                        badgeName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Stack buildStack() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Badge image (e.g., medal)
                Image(
                  image: badgeImage,
                  width: 46,
                  height: 46,
                ),
                Text(
                  level,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                // Text info
              ],
            ),
            Expanded(
              child: Text(
                badgeName,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),

        // Lock image (instead of Icon)
        if (isUnlocked)
          Positioned(
            top: -20,
            right: -15,
            child: Image(
              image: lockIconImage,
              width: 35,
              height: 35,
            ),
          ),
      ],
    );
  }
}
