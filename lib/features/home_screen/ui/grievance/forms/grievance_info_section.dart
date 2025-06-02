import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_categories_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_response_model.dart';
import 'package:ysr_project/features/widget/generic_dropdown_selector.dart';

class GrievanceInfoForm extends StatefulWidget {
  const GrievanceInfoForm({super.key});

  @override
  GrievanceInfoFormState createState() => GrievanceInfoFormState();
}

class GrievanceInfoFormState extends State<GrievanceInfoForm> {
  bool validate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      return true;
    }
    return false;
  }

  final _grievanceEditingController = TextEditingController();
  final grievanceDropDownSelectorKey =
      GlobalKey<AsyncDropdownSelectorState<Grievance>>();
  final _formKey = GlobalKey<FormState>();
  String? categoryName;
  String? grievanceDescription;


  void clearTextFields() {
    categoryName = null;
    grievanceDescription = null;
    _grievanceEditingController.clear();
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('grievance_information'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          AsyncDropdownSelector<GrievanceCategoryResponseModel>(
            key: grievanceDropDownSelectorKey,
            hintText: "grievance".tr(),
            subTitle: "select_grievance".tr(),
            itemsProvider: grievanceCategoriesProvider,
            textEditingController: _grievanceEditingController,
            itemBuilder: (itemContext, entity, isSelected) {
              return ListTile(
                title: Text(
                  entity.categoryName.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  _grievanceEditingController.text =
                      entity.categoryName.toString();

                  setState(() {
                    categoryName = entity.categoryName;
                  });

                  Navigator.pop(context);
                },
              );
            },
            filter: (entity, searchText) {
              return entity.categoryName
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            },
            validator: (value) {
              if (value == "Grievance" || value?.isEmpty == true) {
                return "Please select Grievance";
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Grievance description
          TextFormField(
            decoration: InputDecoration(
              labelText: 'grievance_description'.tr(),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 5, // For lengthy text
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter grievance description';
              }
              return null;
            },
            onSaved: (value) => grievanceDescription = value,
          ),
        ],
      ),
    );
  }
}
