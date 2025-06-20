import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LevelUnlockDialog extends StatelessWidget {
  final String level;
  final String rewardText;
  final String rewardImagePath;
  final String lockIconPath;
  final VoidCallback? onClose;
  final bool isUnlocked;
  final int userPoints;
  final int endPointRange;

  const LevelUnlockDialog({
    super.key,
    required this.level,
    required this.rewardText,
    required this.rewardImagePath,
    required this.lockIconPath,
    required this.isUnlocked,
    required this.userPoints,
    required this.endPointRange,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      level,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      rewardImagePath,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isUnlocked
                          ? "You have unlocked this\nLevel"
                          : "Earn ${NumberFormat('#,###').format(endPointRange - userPoints)} points to unlock \nthis level",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      rewardText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -40,
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.rotate(
                    angle: -0.4712389,
                    child: Image.asset(
                      lockIconPath,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onClose ?? () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
