import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class IdProofForm extends StatefulWidget {
  const IdProofForm({super.key});

  @override
  IdProofFormState createState() => IdProofFormState();
}

class IdProofFormState extends State<IdProofForm> {
  bool validate() {
    if (idProofFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select ID proof')));
      return false;
    }
    return _formKey.currentState?.validate() ?? false;
  }

  final _formKey = GlobalKey<FormState>();
  String? selectedIdProofType;
  File? idProofFile;

  void clear() {
    setState(() {
      selectedIdProofType = null;
      idProofFile = null;
      idProofFileName = null;
    });
  }

  String? idProofFileName;

  List<String> idProofTypes = [
    'Aadhaar Card',
    'PAN Card',
    'Voter ID',
    'Driving License',
    'Passport'
  ];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      final path = result.files.single.path;
      if (path != null) {
        setState(() {
          idProofFile = File(path);
          idProofFileName = result.files.single.name;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'The selected file should be png, jpg, and jpeg format only.'),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("id_proofs".tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          // ID proof type dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'id_proof_type'.tr(),
              border: OutlineInputBorder(),
            ),
            items: idProofTypes.map((String type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedIdProofType = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select ID proof type';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // File upload button and display
          Row(
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                child: Text("upload_id_proof".tr()),
              ),
              SizedBox(width: 16),
              Expanded(
                child: idProofFileName != null
                    ? Text(idProofFileName!, overflow: TextOverflow.ellipsis)
                    : Text('no_file_selected'.tr(),
                        style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),

          if (idProofFile != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'File uploaded successfully!',
                style: TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
