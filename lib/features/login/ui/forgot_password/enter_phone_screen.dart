import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_background_theme.dart';
import 'package:ysr_project/core_widgets/ysr_button.dart';
import 'package:ysr_project/features/login/providers/repo_providers.dart';
import 'package:ysr_project/features/login/ui/forgot_password/otp_screen.dart';

class EnterPhoneScreen extends ConsumerWidget {
  final bool isNewUser;
  final String? email;
  final String? name;
  EnterPhoneScreen({super.key, this.isNewUser = false, this.email, this.name});
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return YsrBackgroundTheme(
        showBackButton: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Gap(40),
              buildPhoneNumberField(context, ref),
              Gap(MediaQuery.of(context).size.height / 2)
            ],
          ),
        ));

  }

  Widget buildPhoneNumberField(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              "Type YourPhone Number",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            Spacer()
          ],
        ),
        Gap(20),
        TextField(
          maxLength: 10,
          controller: phoneNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            hintStyle: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 11),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.textFieldColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Enter your phone number',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        Gap(20),
        YSRButton(
          onPressed: () {
            if (phoneNumberController.text.length < 10) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please enter a valid phone number"),
              ));
              return;
            }
            if (isNewUser) {
              getNewUserOtp(context, ref);
            } else {
              getTop(context, ref);
            }
          },
          child: Text("Send OTP",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      ],
    );
  }
  void getNewUserOtp(BuildContext context, WidgetRef ref) {
    EasyLoading.show();
    ref.read(repoProvider).newUserOtp(phoneNumberController.text).then((value) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("otp Sent scuccessfully"),
      ));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              number: phoneNumberController.text,
              email: email,
              name: name,
              isNewUser: true,
            ),
          ));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(error.toString()),
        ),
      );
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void getTop(BuildContext context, WidgetRef ref) {
    EasyLoading.show();
    ref
        .read(repoProvider)
        .getForgotOtp(phoneNumberController.text)
        .then((value) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("otp Sent scuccessfully"),
      ));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              number: phoneNumberController.text,
            ),
          ));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(error.toString()),
        ),
      );
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }


}
