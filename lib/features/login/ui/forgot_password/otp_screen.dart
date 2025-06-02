import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/login/providers/repo_providers.dart';
import 'package:ysr_project/features/login/ui/forgot_password/reset_password.dart';
import 'package:ysr_project/features/login/ui/login_screen.dart';
import 'package:ysr_project/features/login/ui/signup_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final bool isNewUser;
  final String number;
  final String? email;
  final String? name;
  const OtpScreen(
      {super.key,
      required this.number,
      this.isNewUser = false,
      this.email,
      this.name});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _allFieldsValid = false;

  Timer? _timer;
  int _secondsRemaining = 60;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _allFieldsValid = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _allFieldsValid = _controllers.every((element) => element.text.isNotEmpty);
    setState(() {});
  }

  String getOtpString() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OTP Verification',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              'Enter the Verification Code we Just sent to Your Number +91${widget.number}',
            ),
            Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => _onChanged(value, index),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Didn\'t receive the OTP?',
                  ),
                  Gap(4),
                  InkWell(
                    onTap: () async {
                      _timer?.cancel();

                      _secondsRemaining = 60;
                      _startTimer();
                      _controllers.forEach((element) => element.clear());
                      if (widget.isNewUser) {
                        getNewUserOtp(context, ref);
                      } else {
                        getOtp(context, ref);
                      }
                    },
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Gap(4),
                  Text(
                    _secondsRemaining > 0
                        ? ' 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                        : '',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50)),
              onPressed: _allFieldsValid
                  ? () {
                      if (widget.isNewUser) {
                        verifyNewUserOtp(context, ref);
                      } else {
                        verifyOtp(context, ref);
                      }
                    }
                  : null,
              child: Text(
                'Verify',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Gap(100)
          ],
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context, WidgetRef ref) {
    EasyLoading.show();
    ref
        .read(repoProvider)
        .verifyForgotOtp(widget.number, getOtpString())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Otp verified scuccessfully"),
      ));

      EasyLoading.dismiss();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPassword(widget.number),
          ));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
      EasyLoading.dismiss();
    });
  }

  void verifyNewUserOtp(BuildContext context, WidgetRef ref) {
    EasyLoading.show();
    ref
        .read(repoProvider)
        .verifyNewUserOtp(widget.number, getOtpString())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Otp verified successfully"),
      ));
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(
            phone: widget.number,
            email: widget.email,
            name: widget.name,
          ),
        ),
      );
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
      EasyLoading.dismiss();
    });
  }

  void getOtp(BuildContext context, WidgetRef ref) {
    EasyLoading.show();
    ref.read(repoProvider).getForgotOtp(widget.number).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("otp Sent scuccessfully"),
      ));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void getNewUserOtp(BuildContext context, WidgetRef ref) {
    EasyLoading.show();
    ref.read(repoProvider).newUserOtp(widget.number).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("otp Sent scuccessfully"),
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
