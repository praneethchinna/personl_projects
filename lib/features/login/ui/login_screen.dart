import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_background_theme.dart';
import 'package:ysr_project/core_widgets/ysr_button.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
import 'package:ysr_project/features/home_screen/ui/home_screen/home_tab_screen.dart';
import 'package:ysr_project/features/login/providers/login_provider.dart';
import 'package:ysr_project/features/login/providers/repo_providers.dart';
import 'package:ysr_project/features/login/ui/forgot_password/enter_phone_screen.dart';
import 'package:ysr_project/features/login/ui/signup_screen.dart';
import 'package:ysr_project/features/widget/show_error_dialog.dart';
import 'package:ysr_project/services/google_sign_in/google_sign_in_helper.dart';

import 'initial_screens.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  UserCredential? userCredential;
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool ismobileNumeberEmpty = true;
  bool isPasswordEmpty = true;
  String? _mobileErrorText;
  String? _passwordErrorText;

  @override
  void initState() {
    _emailController.addListener(() {
      setState(() {
        ismobileNumeberEmpty = _emailController.text.trim().length < 10;
        _mobileErrorText =
            ismobileNumeberEmpty ? 'Mobile number should be 10 digits' : null;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        isPasswordEmpty = _passwordController.text.trim().length < 8;
        _passwordErrorText =
            isPasswordEmpty ? 'Password should be minimum 8 characters' : null;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YsrBackgroundTheme(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Mobile Number or Email',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 11),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textFieldColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                errorText: _mobileErrorText,
                hintText: 'Enter Your Mobile Number',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Password',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 11),
                hintText: 'Enter Your Password',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textFieldColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                errorText: _passwordErrorText,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterPhoneScreen()));
                },
                child: Text('Forgot Password?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: YSRButton(
                  onPressed: () {
                    if (_mobileErrorText != null ||
                        _passwordErrorText != null) {
                      return;
                    }

                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please fill all the fields'),
                      ));
                      return;
                    }
                    EasyLoading.show();
                    ref
                        .read(repoProvider)
                        .login(_emailController.text, _passwordController.text)
                        .then((value) async {
                      EasyLoading.dismiss();
                      if (value) {
                        showSuccessDialog(context);
                      } else {
                        ErrorDialog(
                          title: 'Error',
                          message: "something went wrong",
                        );
                      }
                    }, onError: (error, stackTrace) {
                      EasyLoading.dismiss();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => ErrorDialog(
                          title: 'Login Failed',
                          message:
                              error.toString().replaceAll('Exception: ', ''),
                        ),
                      );
                    }).whenComplete(() {
                      EasyLoading.dismiss();
                    });
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  )),
            ),
            SizedBox(height: 20),
            Center(
                child: Text(
              'Or Sign-in With',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueAccent),
            )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: OutlinedButton.icon(
                onPressed: () async {
                  EasyLoading.show();
                  signInWithGoogle().then((result) async {
                    userCredential = result;
                    if (userCredential == null) {
                      EasyLoading.dismiss();
                      throw Error();
                    }
                    final value = userCredential?.user?.email;
                    return ref.read(repoProvider).signInGoogleWithEmail(value!);
                  }).then((value) {
                    EasyLoading.dismiss();
                    if (value) {
                      showSuccessDialog(context);
                    } else {
                      final name = userCredential?.user?.displayName;
                      final email = userCredential?.user?.email;
                      final notifier = ref.read(signupProvider.notifier);
                      notifier.updateEmail(email ?? "");
                      notifier.updateFullName(name ?? "");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnterPhoneScreen(
                                  email: email,
                                  name: name,
                                  isNewUser: true,
                                )),
                      );
                    }
                  }).catchError((e, stack) {
                    showDialog(
                      context: context,
                      builder: (builder) => ErrorDialog(
                        title: 'Error',
                        message: e.toString(),
                      ),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => SignupScreen()),
                    // );
                  }).whenComplete(() {
                    EasyLoading.dismiss();
                  });
                },
                icon: Image.asset('assets/google.png', height: 35),
                label: Text(
                  'Sign in with Google',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  minimumSize: Size(0, 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: AppColors.textFieldColor,
                        width: 1.0,
                      )),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterPhoneScreen(
                                isNewUser: true,
                              )),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    EasyLoading.dismiss();
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing manually
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50)
                    .animate()
                    .scale()
                    .then()
                    .shimmer(),
                SizedBox(height: 10),
                Text(
                  "Login Successful!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Wait for 2 seconds and navigate to next screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close dialog
      ref.invalidate(homeFeedNotifierProvider);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeTabScreen()),
      );
    });
  }
}
