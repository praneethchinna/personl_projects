import 'package:flutter/material.dart';
import 'package:ysr_project/colors/app_colors.dart';

class YSRButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const YSRButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 35,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [AppColors.dustyLavender, AppColors.mistyMorn],
                )
              : LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade300],
                ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
