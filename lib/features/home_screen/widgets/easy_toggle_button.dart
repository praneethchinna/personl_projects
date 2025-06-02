import 'package:flutter/material.dart';
import 'package:ysr_project/colors/app_colors.dart';

class EasyToggleButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> changed;
  const EasyToggleButton(
      {super.key, required this.initialValue, required this.changed});

  @override
  State<EasyToggleButton> createState() => _EasyToggleButtonState();
}

class _EasyToggleButtonState extends State<EasyToggleButton> {
  late bool isOn;

  @override
  void initState() {
    isOn = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = !isOn;
        });
        widget.changed(isOn);
      },
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: isOn
                    ? BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5))
                    : null,
                child: Text(
                  "A",
                  style: TextStyle(
                      color: isOn ? Colors.white : AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: !isOn
                    ? BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5))
                    : null,
                child: Text(
                  "ఆ",
                  style: TextStyle(
                      color: !isOn ? Colors.white : AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
