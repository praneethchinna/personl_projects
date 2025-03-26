import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/ui/home_tab_screen.dart';
import 'package:ysr_project/features/login/providers/login_provider.dart';
import 'package:ysr_project/features/login/providers/repo_providers.dart';
import 'package:ysr_project/features/login/ui/forgot_password/forgot_otp_screen.dart';
import 'package:ysr_project/features/login/ui/otp_screen.dart';
import 'package:ysr_project/features/login/ui/signup_screen.dart';
import 'package:ysr_project/features/widget/show_error_dialog.dart';
import 'package:ysr_project/services/google_sign_in/google_sign_in_helper.dart';

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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Mobile Number or Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      errorText: _mobileErrorText,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
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
                                builder: (context) => ForgotOtpScreen()));
                      },
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_mobileErrorText != null ||
                          _passwordErrorText != null) {
                        return;
                      }
                      EasyLoading.show();
                      ref
                          .read(repoProvider)
                          .login(
                              _emailController.text, _passwordController.text)
                          .then((value) async {
                        EasyLoading.dismiss();
                        if (value) {
                          EasyLoading.dismiss();
                          _showSuccessDialog(context);
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
                            builder: (builder) => ErrorDialog(
                                  title: 'Error',
                                  message: error.toString(),
                                ));
                      }).whenComplete(() {
                        EasyLoading.dismiss();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.oceanBlue,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                      child: Text(
                    'Or Sign-in With',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )),
                  SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () async {
                      if (Platform.isIOS) {
                        return;
                      }
                      EasyLoading.show();
                      signInWithGoogle().then((result) async {
                        userCredential = result;
                        if (userCredential == null) {
                          EasyLoading.dismiss();
                          throw Error();
                        }
                        final value = userCredential?.user?.email;
                        return ref
                            .read(repoProvider)
                            .signInGoogleWithEmail(value!);
                      }).then((value) {
                        if (value) {
                          _showSuccessDialog(context);
                        } else {
                          final name = userCredential?.user?.displayName;
                          final email = userCredential?.user?.email;
                          final notifier = ref.read(signupProvider.notifier);
                          notifier.updateEmail(email ?? "");
                          notifier.updateFullName(name ?? "");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen(
                                      email: email,
                                      name: name,
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
                    icon: Image.asset('assets/google2.png', height: 35),
                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
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
                Icon(Icons.check_circle, color: Colors.green, size: 50),
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeTabScreen()),
      );
    });
  }
}
