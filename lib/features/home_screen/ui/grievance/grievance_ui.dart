import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/forms/grievance_info_section.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/forms/id_proofs_section.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/forms/personal_info_form.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/forms/selfie_capture_section.dart';
import 'package:ysr_project/features/home_screen/ui/grievance/girievance_tab.dart';

class GrievanceFormStepper extends ConsumerStatefulWidget {
  final List<CameraDescription> cameras;

  const GrievanceFormStepper({Key? key, required this.cameras})
      : super(key: key);

  @override
  _GrievanceFormStepperState createState() => _GrievanceFormStepperState();
}

class _GrievanceFormStepperState extends ConsumerState<GrievanceFormStepper> {
  int currentStep = 0;

  // Form keys to validate each section
  final personalInfoFormKey = GlobalKey<PersonalInfoFormState>();
  final grievanceFormKey = GlobalKey<GrievanceInfoFormState>();
  final idProofFormKey = GlobalKey<IdProofFormState>();
  final selfieFormKey = GlobalKey<SelfieCaptureFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepContinue: () async {
          bool isValid = false;

          // Validate the current form
          switch (currentStep) {
            case 0:
              isValid = personalInfoFormKey.currentState!.validate();
              break;
            case 1:
              isValid = grievanceFormKey.currentState!.validate();
              break;
            case 2:
              isValid = idProofFormKey.currentState!.validate();
              break;
            case 3:
              isValid = true;
              break;
          }

          if (isValid) {
            if (currentStep < 3) {
              setState(() {
                currentStep += 1;
              });
            } else {
              // Submit the form
              await _submitForm();
            }
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('personal_information'.tr()),
            content: PersonalInfoForm(key: personalInfoFormKey),
            isActive: currentStep >= 0,
          ),
          Step(
            title: Text('grievance_information'.tr()),
            content: GrievanceInfoForm(key: grievanceFormKey),
            isActive: currentStep >= 1,
          ),
          Step(
            title: Text('id_proofs'.tr()),
            content: IdProofForm(key: idProofFormKey),
            isActive: currentStep >= 2,
          ),
          Step(
            title: Text('selfie_capture'.tr()),
            content:
                SelfieCaptureForm(cameras: widget.cameras, key: selfieFormKey),
            isActive: currentStep >= 3,
          ),
        ],
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    currentStep == 3 ? 'submit'.tr() : 'next'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (currentStep > 0)
                  ElevatedButton(
                    onPressed: details.onStepCancel,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (selfieFormKey.currentState!.validate() == false) {
      return;
    }

    final selfieFormState = selfieFormKey.currentState!;
    final file = selfieFormState.selfieImage;

    final idProofFormState = idProofFormKey.currentState!;
    final idProofType = idProofFormState.selectedIdProofType;
    final idProofFile = idProofFormState.idProofFile;

    final grievanceFormState = grievanceFormKey.currentState!;
    final categoryName = grievanceFormState.categoryName;
    final grievanceDescription = grievanceFormState.grievanceDescription;

    final personalInfoFormState = personalInfoFormKey.currentState!;
    final name = personalInfoFormState.name;
    final gender = personalInfoFormState.gender;
    final email = personalInfoFormState.email;
    final parliament = personalInfoFormState.parliament;
    final assembly = personalInfoFormState.assembly;
    EasyLoading.show();

    await ref
        .read(homeFeedRepoProvider)
        .submitGrievance(
          name: name!,
          gender: gender!,
          email: email ?? '',
          parliament: parliament!,
          assembly: assembly!,
          categoryName: categoryName!,
          grievanceDescription: grievanceDescription!,
          idProofType: idProofType!,
          selfie: file,
          idProof: idProofFile,
        )
        .then((value) {
      if (value) {
        selfieFormState.clearSelfieImage();
        idProofFormState.clear();
        grievanceFormState.clearTextFields();
        personalInfoFormState.clearData();

        ref.read(grievanceFormTabController.notifier).state = 1;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submission failed!')),
        );
      }
    }, onError: (error, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }
}
