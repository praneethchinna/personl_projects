import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelfieCaptureForm extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SelfieCaptureForm({super.key, required this.cameras});

  @override
  SelfieCaptureFormState createState() => SelfieCaptureFormState();
}

class SelfieCaptureFormState extends State<SelfieCaptureForm> {
  CameraController? controller;
  XFile? selfieImage;
  bool isCameraInitialized = false;

  void clearSelfieImage() {
    setState(() {
      selfieImage = null;
    });
  }

  bool validate() {
    if (selfieImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please take selfie')));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      // Initialize the front camera
      controller = CameraController(
        widget.cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => widget.cameras.first,
        ),
        ResolutionPreset.medium,
      );

      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          isCameraInitialized = true;
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (controller != null && controller!.value.isInitialized) {
      try {
        final XFile photo = await controller!.takePicture();
        setState(() {
          selfieImage = photo;
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error capturing photo: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('selfie_capture'.tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        if (selfieImage == null) ...[
          // Camera preview
          if (isCameraInitialized)
            SizedBox(
              height: 300,
              width: double.infinity,
              child: CameraPreview(controller!),
            )
          else
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(child: Text('Initializing camera...')),
            ),

          SizedBox(height: 16),

          // Capture button
          Center(
            child: ElevatedButton(
              onPressed: isCameraInitialized ? _takePhoto : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Text('selfie_capture'.tr()),
              ),
            ),
          ),
        ] else ...[
          // Display captured selfie
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(selfieImage!.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Retake button
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selfieImage = null;
                });
              },
              child: Text('Retake Selfie'),
            ),
          ),
        ],
      ],
    );
  }
}
