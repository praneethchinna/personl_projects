import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/gallery/providers/gallery_specific_event_provider.dart';
import 'package:ysr_project/features/gallery/ui/gallary_ui.dart';

class SpecificEventUi extends ConsumerWidget {
  final String eventId;
  final String date;
  const SpecificEventUi({super.key, required this.eventId, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(galleryImageProvider(eventId).notifier);
    final state = ref.watch(galleryImageProvider(eventId));

    return Scaffold(
        appBar: YsrAppBar(
          centerTitle: true,
          title: Text(
            'Gallery',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Event:   $eventId",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Date:   $date",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
            Gap(10),
            Expanded(
              child: state.when(
                data: (data) {
                  final images = data.galleryResponseModel.images;
                  if (images.isEmpty) {
                    return Center(
                        child: Text('No images available for this event.'));
                  }
                  return GalleryWidget(
                    galleryImageNotifier: notifier,
                    functionality: () {},
                    viewModel: data,
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ));
  }
}
