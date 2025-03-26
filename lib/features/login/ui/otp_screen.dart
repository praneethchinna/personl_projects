import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/login/providers/login_provider.dart';
import 'package:ysr_project/features/login/providers/repo_providers.dart';
import 'package:ysr_project/features/login/ui/signup_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final numberController = TextEditingController();
  final otpController = TextEditingController();
  bool isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade100,
                        Colors.white,
                        Colors.green.shade100
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/ysr.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 50),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back))
                      ],
                    ),
                    SizedBox(height: 150),
                    Text(
                      'OTP Screen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mobile Number',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: numberController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Enter mobile number',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    if (isOtpSent) ...[
                      Gap(30),
                      Text(
                        'OTP',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: otpController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: 'Enter OTP',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                    Gap(30),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (numberController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Please enter mobile number",
                              ),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }
                          if (isOtpSent && otpController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Please enter otp",
                              ),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }
                          if (isOtpSent) {
                            verifyOtp();
                          } else {
                            getTop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.oceanBlue,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isOtpSent ? 'VERIFY OTP' : 'GET OTP',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void verifyOtp() {
    EasyLoading.show();
    ref
        .read(repoProvider)
        .verifyOtp(numberController.text, otpController.text)
        .then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Otp verified scuccessfully")));
      ref
          .read(signupProvider.notifier)
          .updateMobileNumber(numberController.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignupScreen(
                    phone: numberController.text,
                  )));
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      EasyLoading.dismiss();
    });
  }

  void getTop() {
    EasyLoading.show();
    ref.read(repoProvider).getOtp(numberController.text).then((value) {
      setState(() {
        isOtpSent = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("otp Sent scuccessfully")));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }
}
