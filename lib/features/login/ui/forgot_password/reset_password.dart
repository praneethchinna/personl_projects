import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_background_theme.dart';
import 'package:ysr_project/core_widgets/ysr_button.dart';
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
    return YsrBackgroundTheme(
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _passwordController,
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
                    labelText: 'New Password',
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
              Gap(40),
              TextFormField(
                controller: _confirmPasswordController,
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
                    labelText: 'Confirm Password',
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
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  YSRButton(
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Password Reset successfully"),
                          ));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        }).onError((error, stackTrace) {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error.toString()),
                          ));
                        });
                      }
                    },
                    child: Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Gap(500),
            ],
          ),
        ),
      ),
    );
  }
}
