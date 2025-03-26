import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/login/providers/repo_providers.dart';
import 'package:ysr_project/features/login/ui/login_screen.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword(this.phoneNumber, {super.key});
  final String phoneNumber;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
                      'RESET Password',
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
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'New Password',
                          border: const OutlineInputBorder(),
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
                          )),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter new password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    Gap(20),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          )),
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();
                            ref
                                .read(repoProvider)
                                .resetPassword(
                                  widget
                                      .phoneNumber, // Assuming mobile number is handled elsewhere
                                  _passwordController.text,
                                )
                                .then((value) {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Password Reset successfully"),
                              ));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ));
                            }).onError((error, stackTrace) {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(error.toString()),
                              ));
                            });
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
                          'Reset Password',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
