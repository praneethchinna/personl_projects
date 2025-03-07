import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/login/providers/login_provider.dart';
import 'package:ysr_project/features/login/ui/select_location_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final String? email;
  final String? name;
  const SignupScreen({super.key, this.email, this.name});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String _selectedGender = 'Male';
  bool _isPasswordVisible = false;
  late TextEditingController _nameController;
  final _phoneNoController = TextEditingController();
  final _passwordController = TextEditingController();
  late TextEditingController _emailController;
  String? _emailErrorText;
  bool isEmailEmpty = true;
  String? _mobileErrorText;
  String? _passwordErrorText;
  bool ismobileNumeberEmpty = true;
  bool isPasswordEmpty = true;
  bool isNameEmpty = true;

  @override
  void initState() {
    isNameEmpty = widget.name == null;

    _emailController = TextEditingController(text: widget.email ?? "");
    _nameController = TextEditingController(text: widget.name ?? "");
    _nameController.addListener(() {
      setState(() {
        isNameEmpty = _nameController.text.isEmpty;
      });
    });
    _phoneNoController.addListener(() {
      setState(() {
        ismobileNumeberEmpty = _phoneNoController.text.trim().length < 10;
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
    _emailController.addListener(() {
      setState(() {
        isEmailEmpty = !isValidEmail(_emailController.text);
        _emailErrorText = isEmailEmpty ? "email should be valid" : null;
      });
    });
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
    final state = ref.watch(signupProvider);

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
                      'CREATE YOUR ACCOUNT',
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
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Full Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        onChanged: (value) {
                          notifier.updateFullName(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Your Full Name',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mobile Number",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _phoneNoController,
                        onChanged: (value) {
                          notifier.updateMobileNumber(value);
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Mobile Number',
                          hintStyle: TextStyle(color: Colors.grey),
                          errorText: _mobileErrorText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        onChanged: (value) {
                          notifier.updateEmail(value);
                        },
                        decoration: InputDecoration(
                          errorText: _emailErrorText,
                          hintText: 'Enter Your email Id',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        onChanged: (value) {
                          notifier.updatePassword(value);
                        },
                        obscureText: _isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          errorText: _passwordErrorText,
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (isNameEmpty ||
                          isEmailEmpty ||
                          isPasswordEmpty ||
                          ismobileNumeberEmpty) {
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectLocationScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.oceanBlue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
        height: 60,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
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
