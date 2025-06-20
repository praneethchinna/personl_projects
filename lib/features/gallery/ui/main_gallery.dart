import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/gallery/ui/gallery_summary_ui.dart';

class MainGalleryUi extends ConsumerStatefulWidget {
  const MainGalleryUi({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainGalleryUiState();
}

class _MainGalleryUiState extends ConsumerState<MainGalleryUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YsrAppBar(
        title: Text(
          'gallery'.tr(),
        ),
        centerTitle: true,
      ),
      body: GallerySummaryPage(),
    );
  }
}
