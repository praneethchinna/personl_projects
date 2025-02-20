import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/login/providers/login_provider.dart';
import 'package:ysr_project/features/login/providers/repo_providers.dart';
import 'package:ysr_project/features/login/response_models/assembly_response_model.dart';
import 'package:ysr_project/features/login/response_models/country_state_response_model.dart';
import 'package:ysr_project/features/login/response_models/parliament_response_model.dart';
import 'package:ysr_project/features/login/ui/login_screen.dart';
import 'package:ysr_project/features/widget/generic_dropdown_selector.dart';
import 'package:ysr_project/features/widget/show_error_dialog.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

class SelectLocationScreen extends ConsumerStatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectLocationScreen> createState() =>
      _SelectLocationScreenState();
}

class _SelectLocationScreenState extends ConsumerState<SelectLocationScreen> {
  final parliamentTFController = TextEditingController();
  final assemblyTFController = TextEditingController();

  List<Parliament> parliaments = [];
  @override
  void initState() {
    super.initState();
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
                      'Select Your Country',
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
              child: Column(children: [
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search country...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  items: (String filter, LoadProps? props) {
                    List<String> allCountries =
                        CountryStateResponseModel.country;
                    return allCountries
                        .where((country) => country
                            .toLowerCase()
                            .contains(filter.toLowerCase()))
                        .toList();
                  },
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Country ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (String? value) {
                    print('Selected country: $value');
                    notifier.updateCountry(value);
                  },
                ),
                SizedBox(height: 20),
                if (state.country != null &&
                    state.country?.toLowerCase() == "india")
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      showSelectedItems: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "Search State...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    items: (String filter, LoadProps? props) {
                      List<String> allStates = CountryStateResponseModel.state;
                      return allStates
                          .where((state) => state
                              .toLowerCase()
                              .contains(filter.toLowerCase()))
                          .toList();
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: 'State ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (String? value) {
                      notifier.updateState(value);
                      print('Selected State: $value');
                    },
                  ),
                SizedBox(height: 20),
                AsyncDropdownSelector<Parliament>(
                  hintText: "Parliament",
                  subTitle: "Select Parliament",
                  itemsProvider: parliamentProvider,
                  textEditingController: parliamentTFController,
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
                        notifier.updateParliament(entity);
                        parliamentTFController.text =
                            entity.parliamentName.toString();
                        Navigator.pop(itemContext);
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
                if (state.parliament != null)
                  AsyncDropdownSelector<Assembly>(
                    hintText: "Assembly",
                    subTitle: "Select Assembly",
                    itemsProvider:
                        assemblyProvider(state.parliament!.parliamentId),
                    textEditingController: assemblyTFController,
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
                          notifier.updateAssembly(entity);
                          assemblyTFController.text =
                              entity.assemblyName.toString();
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
                SizedBox(height: 90),
                ElevatedButton(
                  onPressed: state.country != null &&
                          state.state != null &&
                          parliamentTFController.text.isNotEmpty &&
                          assemblyTFController.text.isNotEmpty
                      ? () {
                          EasyLoading.show();
                          ref.read(repoProvider).updateUserDetails().then(
                              (value) {
                            EasyLoading.dismiss();
                            if (value) {
                              _showSuccessDialog(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => ErrorDialog(
                                      title: "somthing went wrong",
                                      message: "can't sign up"));
                            }
                          }, onError: (error, stackTrace) {
                            EasyLoading.dismiss();
                            showDialog(
                                context: context,
                                builder: (context) => ErrorDialog(
                                    title: "somthing went wrong",
                                    message: error.toString()));
                          }).whenComplete(() {
                            EasyLoading.dismiss();
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.oceanBlue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Text(
                    'Finish',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
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
                  "Signup Successful!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }
}

final parliamentProvider =
    FutureProvider.autoDispose<List<Parliament>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get<List<dynamic>>('/parliaments');
  if (response.statusCode == 200) {
    if (response.data == null || (response.data as List).isEmpty) {
      return [];
    }
    return (response.data as List).map((e) => Parliament.fromJson(e)).toList();
  } else {
    return throw Exception("Failed fetch Assembly");
  }
});

final assemblyProvider =
    FutureProvider.autoDispose.family<List<Assembly>, int>((ref, id) async {
  final dio = ref.read(dioProvider);
  final response =
      await dio.get<List<dynamic>>('/assemblies?parliament_id=$id');
  if (response.statusCode == 200) {
    if (response.data == null || (response.data as List).isEmpty) {
      return [];
    }
    return (response.data as List).map((e) => Assembly.fromJson(e)).toList();
  } else {
    return throw Exception("Failed fetch Assembly");
  }
});
