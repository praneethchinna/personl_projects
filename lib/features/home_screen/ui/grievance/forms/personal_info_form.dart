import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/login/response_models/assembly_response_model.dart';
import 'package:ysr_project/features/login/response_models/parliament_response_model.dart';
import 'package:ysr_project/features/login/ui/select_location_screen.dart';
import 'package:ysr_project/features/widget/generic_dropdown_selector.dart';

class PersonalInfoForm extends ConsumerStatefulWidget {
  const PersonalInfoForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      PersonalInfoFormState();
}

class PersonalInfoFormState extends ConsumerState<PersonalInfoForm> {
  bool validate() {
    if (_formKey.currentState!.validate() &&
        (parliamentDropDownSelectorKey.currentState!.validate() &&
            assemblyDropDownSelectorKey.currentState!.validate())) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _parliamentController = TextEditingController();
  final TextEditingController _constituencyController = TextEditingController();

  final parliamentDropDownSelectorKey =
      GlobalKey<AsyncDropdownSelectorState<Parliament>>();
  final assemblyDropDownSelectorKey =
      GlobalKey<AsyncDropdownSelectorState<Assembly>>();

  int parliamentId = 0;

  String? name;
  String? gender;

  String? email;
  String? parliament;
  String? assembly;

  void clearData() {
    _formKey.currentState!.reset();
    _parliamentController.clear();
    _constituencyController.clear();
    name = null;
    gender = null;
    email = null;
    parliament = null;
    assembly = null;
  }

  List<String> genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('personal_information'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'full_name'.tr(),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onSaved: (value) => name = value,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'gender'.tr(),
              border: OutlineInputBorder(),
            ),
            items: genders.map((String gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                gender = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'email'.tr(),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onSaved: (value) => email = value,
          ),
          SizedBox(height: 16),
          AsyncDropdownSelector<Parliament>(
            key: parliamentDropDownSelectorKey,
            hintText: "select_parliament".tr(),
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
                  _parliamentController.text = entity.parliamentName.toString();
                  parliamentId = entity.parliamentId;
                  setState(() {
                    parliament = entity.parliamentName.toString();
                  });

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
              if (value == "Parliament" || value?.isEmpty == true) {
                return "Please select Parliament";
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          AsyncDropdownSelector<Assembly>(
            key: assemblyDropDownSelectorKey,
            hintText: "select_assembly".tr(),
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
                  _constituencyController.text = entity.assemblyName.toString();
                  setState(() {
                    assembly = entity.assemblyName.toString();
                  });
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
        ],
      ),
    );
  }
}
