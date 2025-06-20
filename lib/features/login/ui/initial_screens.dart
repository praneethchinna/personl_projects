import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ysr_project/colors/app_colors.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({
    super.key,
    required this.title1,
    required this.title2,
    required this.image,
    required this.buttonTitle,
    required this.onPressed,
  });

  final String title1;
  final String title2;
  final String image;
  final String buttonTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.initalScreenColor1,
            AppColors.initalScreenColor2,
            Colors.white
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(100),
            Text(
              textAlign: TextAlign.center,
              title1,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E1861),
              ),
            ),
            Gap(10),
            Text(
              textAlign: TextAlign.center,
              title2,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Gap(10),
            Image.asset(
              image,
              width: 400,
              height: 400,
            ),
            SizedBox(height: 50),
            OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              child: Text(
                buttonTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
