import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/phone.jpg',
              width: 500,
              height: 500,
              fit: BoxFit.contain,
            ),
            Positioned(
              top: 470,
              left: 20,
              right: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: buildPhoneNumberField(context, ref),
              ),
            )
          ],
        ),
      ).animate().shimmer(duration: 1000.ms),
    );
  }

  Widget buildPhoneNumberField(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone Number",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Gap(20),
        TextField(
          maxLength: 10,
          controller: phoneNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            hintText: '99999999999',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        Gap(20),
        ElevatedButton(
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
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.primaryColor,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          child: Text("Send OTP"),
        )
      ],
    );
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
}
