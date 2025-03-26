import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/repository/home_feeds_repo_impl.dart';
import 'package:ysr_project/features/login/response_models/assembly_response_model.dart';
import 'package:ysr_project/features/login/response_models/parliament_response_model.dart';
import 'package:ysr_project/features/login/ui/select_location_screen.dart';
import 'package:ysr_project/features/profile/provider/profileProvider.dart';
import 'package:ysr_project/features/widget/generic_dropdown_selector.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val, val1) {
        if(savedSuccessfully){
        ref.invalidate(profileAsyncProvider);}
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Profile Edit'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: switch (true) {
                _ when isLoading =>
                  const Center(child: CircularProgressIndicator()),
                _ when errorMessage.isNotEmpty =>
                  Center(child: Text(errorMessage)),
                _ => SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Initicon(
                          size: 100,
                          text: _nameController.text,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
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
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Country',
                          ),
                          controller: _countryController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your country';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'State',
                          ),
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
                          hintText: "Parliament",
                          subTitle: "Select Parliament",
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
                          hintText: "Assembly",
                          subTitle: "Select Assembly",
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
                            if (value == "Assembly" || value?.isEmpty == true) {
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
                        ElevatedButton(
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
                                  constituency: _constituencyController.text,
                                );
                                if (isSuccess) {
                                  setState(() {
                                    savedSuccessfully = true;
                                  });
                                  EasyLoading.showSuccess(
                                      'Profile updated successfully');
                                } else {
                                  EasyLoading.showError(
                                      'Failed to update profile');
                                }
                              } catch (e) {
                                EasyLoading.showError('An error occurred: $e');
                              } finally {
                                EasyLoading.dismiss();
                              }
                            }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),
              }),
        ),
      ),
    );
  }
}
