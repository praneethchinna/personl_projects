import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/core_widgets/ysr_buttons.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/login/response_models/assembly_response_model.dart';
import 'package:ysr_project/features/login/response_models/country_state_response_model.dart';
import 'package:ysr_project/features/login/response_models/parliament_response_model.dart';
import 'package:ysr_project/features/login/ui/select_location_screen.dart';
import 'package:ysr_project/features/profile/provider/profileProvider.dart';
import 'package:ysr_project/features/profile/ui/profile_save_success_page.dart';
import 'package:ysr_project/features/widget/generic_dropdown_selector.dart';
import 'package:ysr_project/services/shared_preferences/shared_preferences_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  final String phoneNumber;

  const ProfileEdit({
    super.key,
    required this.phoneNumber,
  });

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _parliamentController = TextEditingController();
  final TextEditingController _constituencyController = TextEditingController();

  bool isLoading = true;
  String errorMessage = "";
  int parliamentId = 0;
  bool savedSuccessfully = false;

  @override
  void initState() {
    updateForm();
    super.initState();
  }

  Future<void> updateForm() async {
    try {
      final profileData =
          await ref.read(profileAsyncProvider(widget.phoneNumber).future);
      final temp = await ref.read(parliamentProvider.future);

      if (profileData != null) {
        _nameController.text = profileData.name;
        _genderController.text = profileData.gender;
        _emailController.text = profileData.email;
        _countryController.text = profileData.country;
        _stateController.text = profileData.state;
        _parliamentController.text = profileData.parliament;
        _constituencyController.text = profileData.constituency;
      }
      final parliamentData = temp.firstWhere((element) =>
          element.parliamentName.toLowerCase() ==
          _parliamentController.text.toLowerCase());
      parliamentId = parliamentData.parliamentId;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _parliamentController.dispose();
    _constituencyController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  Widget buildDetailsTextField({
    required String subTitleText,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subTitleText.tr(), style: subTitleTextStyle()),
        Gap(7),
        TextFormField(
          decoration: InputDecoration(
            hintStyle: customHintTextStyle(),
            labelStyle: customTextStyle(),
            suffixIconColor: Colors.green,
            border: appBorder(),
            enabledBorder: appEnabledBorder(),
            focusedBorder: appBorder(),
          ),
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val, val1) {
        if (savedSuccessfully) {
          ref.invalidate(profileAsyncProvider);
        }
      },
      child: Scaffold(
        appBar: YsrAppBar(
          centerTitle: true,
          title: Text('profile_edit'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: switch (true) {
                _ when isLoading =>
                  const Center(child: CircularProgressIndicator.adaptive()),
                _ when errorMessage.isNotEmpty =>
                  Center(child: Text(errorMessage)),
                _ => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildDetailsTextField(
                            subTitleText: "name",
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintStyle: customHintTextStyle(),
                              labelStyle: customTextStyle(),
                              suffixIconColor: Colors.green,
                              border: appBorder(),
                              enabledBorder: appEnabledBorder(),
                              focusedBorder: appBorder(),
                              labelText: 'gender'.tr(),
                            ),
                            value: _genderController.text.isNotEmpty
                                ? _genderController.text
                                : null,
                            items: ['Male', 'Female'].map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _genderController.text = newValue ?? '';
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your Gender';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          buildDetailsTextField(
                            subTitleText: 'email',
                            controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          buildDetailsTextField(
                            subTitleText: 'country',
                            controller: _countryController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your country';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          buildDetailsTextField(
                            subTitleText: 'state',
                            controller: _stateController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your state';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 20),
                          AsyncDropdownSelector<Parliament>(
                            hintStyle: customHintTextStyle(),
                            textStyle: customTextStyle(),
                            subTitleTextStyle: subTitleTextStyle(),
                            suffixIconColor: Colors.green,
                            border: appBorder(),
                            enabledBorder: appEnabledBorder(),
                            hintText: "Parliament",
                            subTitle: "select_parliament".tr(),
                            itemsProvider: parliamentProvider,
                            textEditingController: _parliamentController,
                            itemBuilder: (itemContext, entity, isSelected) {
                              return ListTile(
                                title: Text(
                                  entity.parliamentName.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  _parliamentController.text =
                                      entity.parliamentName.toString();
                                  parliamentId = entity.parliamentId;
                                  setState(() {});

                                  Navigator.pop(context);
                                },
                              );
                            },
                            filter: (entity, searchText) {
                              return entity.parliamentName
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase());
                            },
                            validator: (value) {
                              if (value == "Parliament" ||
                                  value?.isEmpty == true) {
                                return "Please select Parliament";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          AsyncDropdownSelector<Assembly>(
                            hintStyle: customHintTextStyle(),
                            textStyle: customTextStyle(),
                            subTitleTextStyle: subTitleTextStyle(),
                            suffixIconColor: Colors.green,
                            border: appBorder(),
                            enabledBorder: appEnabledBorder(),
                            hintText: "Assembly",
                            subTitle: "select_assembly".tr(),
                            itemsProvider: assemblyProvider(parliamentId),
                            textEditingController: _constituencyController,
                            itemBuilder: (itemContext, entity, isSelected) {
                              return ListTile(
                                title: Text(
                                  entity.assemblyName.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  _constituencyController.text =
                                      entity.assemblyName.toString();
                                  setState(() {});
                                  Navigator.pop(itemContext);
                                },
                              );
                            },
                            filter: (entity, searchText) {
                              return entity.assemblyName
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase());
                            },
                            validator: (value) {
                              if (value == "Assembly" ||
                                  value?.isEmpty == true) {
                                return "Please select Assembly";
                              }
                              return null;
                            },
                          ),
                          // TextFormField(
                          //   decoration: InputDecoration(
                          //     labelText: 'Constituency',
                          //   ),
                          //   controller: _constituencyController,
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'Please enter your Constituency';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          SizedBox(height: 20),
                          YsrButton(
                              width: 269,
                              height: 50,
                              text: "save".tr(),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  EasyLoading.show();
                                  try {
                                    final repoProvider =
                                        ref.read(homeFeedRepoProvider);
                                    final isSuccess =
                                        await repoProvider.updateProfileDetails(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      gender: _genderController.text,
                                      country: _countryController.text,
                                      state: _stateController.text,
                                      parliament: _parliamentController.text,
                                      constituency:
                                          _constituencyController.text,
                                    );
                                    if (isSuccess) {
                                      final prefs = await ref.read(
                                          sharedPreferencesProvider.future);

                                      final temp = ref.read(userProvider);
                                      final user = User(
                                          message: temp.message,
                                          userId: temp.userId,
                                          name: _nameController.text,
                                          role: temp.role,
                                          mobile: temp.mobile,
                                          parliament:
                                              _parliamentController.text,
                                          constituency:
                                              _constituencyController.text);
                                      ref.read(userProvider.notifier).state =
                                          user;
                                      prefs.setString("userData",
                                          jsonEncode(user.toJson()));

                                      setState(() {
                                        savedSuccessfully = true;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileSaveSuccessPage()));
                                    } else {
                                      EasyLoading.showError(
                                          'Failed to update profile');
                                    }
                                  } catch (e) {
                                    EasyLoading.showError(
                                        'An error occurred: $e');
                                  } finally {
                                    EasyLoading.dismiss();
                                  }
                                }
                              },
                              gradientColors: [
                                AppColors.dustyLavender,
                                AppColors.mistyMorn
                              ]),
                          Gap(30),
                        ],
                      ),
                    ),
                  ),
              }),
        ),
      ),
    );
  }

  TextStyle customHintTextStyle() {
    return const TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle customTextStyle() {
    return const TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle subTitleTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  Color suffixIconColor() {
    return Colors.green;
  }

  OutlineInputBorder appBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.green,
        width: 1,
      ),
    );
  }

  OutlineInputBorder appEnabledBorder() {
    return appBorder();
  }
}
