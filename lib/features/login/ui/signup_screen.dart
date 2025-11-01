import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_background_theme.dart';
import 'package:ysr_project/core_widgets/ysr_button.dart';
import 'package:ysr_project/features/login/providers/login_provider.dart';
import 'package:ysr_project/features/login/ui/select_location_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final String? email;
  final String? name;
  final String? phone;
  const SignupScreen({super.key, this.email, this.name, this.phone});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String _selectedGender = 'Male';
  bool _isPasswordVisible = false;
  late TextEditingController _nameController;

  final _passwordController = TextEditingController();
  late TextEditingController _emailController;
  String? _emailErrorText;
  bool isEmailEmpty = true;

  String? _passwordErrorText;

  bool isPasswordEmpty = true;
  bool isNameEmpty = true;
  final _referralCodeController = TextEditingController();

  @override
  void initState() {
    isNameEmpty = widget.name == null;
    isEmailEmpty = widget.email == null;

    _emailController = TextEditingController(text: widget.email ?? "");
    _nameController = TextEditingController(text: widget.name ?? "");

    _nameController.addListener(() {
      setState(() {
        isNameEmpty = _nameController.text.isEmpty;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        isPasswordEmpty = _passwordController.text.trim().length < 8;
        _passwordErrorText =
            isPasswordEmpty ? 'Password should be minimum 8 characters' : null;
      });
    });
    _emailController.addListener(() {
      setState(() {
        isEmailEmpty = !isValidEmail(_emailController.text);
        _emailErrorText = isEmailEmpty ? "email should be valid" : null;
      });
    });
    // if (mounted) {
    //   ref.read(signupProvider.notifier).updateMobileNumber(widget.phone ?? "");
    // }
    super.initState();
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(signupProvider.notifier);

    return YsrBackgroundTheme(
        showBackButton: true,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 8),
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  notifier.updateFullName(value);
                },
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Image.asset(
                        'assets/signup_icons/profile_icon.png',
                        height: 10,
                        width: 10,
                      ),
                    ),
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
                    hintText: 'Enter Your Full Name',
                    filled: true,
                    fillColor: Colors.white),
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderButton('Male'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderButton('Female'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                onChanged: (value) {
                  notifier.updateEmail(value);
                },
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Image.asset(
                      'assets/signup_icons/email_icon.png',
                      height: 5,
                      width: 5,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  errorText: _emailErrorText,
                  hintText: 'Enter Your email Id',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                onChanged: (value) {
                  notifier.updatePassword(value);
                },
                obscureText: _isPasswordVisible,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 14.0),
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(
                      'assets/signup_icons/password_icon.png',
                      height: 5,
                      width: 5,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  hintText: 'Password',
                  errorText: _passwordErrorText,
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
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 8),
              TextField(
                controller: _referralCodeController,
                onChanged: (value) {
                  notifier.updateReferralCode(value);
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 14.0),
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(
                      'assets/signup_icons/referral_icon.png',
                      height: 5,
                      width: 5,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  hintText: 'Enter Referral Code(Optional)',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 30),
              YSRButton(
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (isNameEmpty || isEmailEmpty || isPasswordEmpty) {
                      return;
                    }
                    notifier.updateMobileNumber(widget.phone ?? "");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectLocationScreen()));
                  }),
            ],
          ),
        ));
  }

  Widget _buildGenderButton(String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        height: 45,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? AppColors.textFieldColor
                  : Colors.pinkAccent.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isSelected
                ? [AppColors.initalScreenColor1, AppColors.textFieldColor]
                : [Colors.grey.shade100, Colors.grey.shade100],
          ),
          color: isSelected ? AppColors.electricOcean : Colors.grey.shade100,
        ),
        child: Text(
          gender,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
