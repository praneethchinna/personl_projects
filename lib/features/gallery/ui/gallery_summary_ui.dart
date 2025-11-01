import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ysr_project/features/gallery/providers/gallery_summary_notifier.dart';
import 'package:ysr_project/features/gallery/ui/specific_event_ui.dart';

class GallerySummaryPage extends ConsumerStatefulWidget {
  const GallerySummaryPage({super.key});

  @override
  ConsumerState<GallerySummaryPage> createState() => _GallerySummaryPageState();
}

class _GallerySummaryPageState extends ConsumerState<GallerySummaryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final threshold = 100.0;
    final position = _scrollController.position;
    if (position.pixels > position.maxScrollExtent - threshold) {
      ref.read(gallerySummaryProvider.notifier).fetchNextGallerySummary();
    }
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(gallerySummaryProvider);

    return Scaffold(
      appBar: null,
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (state) {
          final events = state.events;
          final isLoadingMore = state.isLoading;

          if (events.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            controller: _scrollController,
            itemCount: events.length + (state.hasNext ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < events.length) {
                final event = events[index];
                if (event.sampleImage == null ||
                    (event.sampleImage?.split(".").last != "jpg" &&
                        event.sampleImage?.split(".").last != "jpeg")) {
                  return const SizedBox.shrink();
                }
                log("http://3.82.180.105:8000/api${event.sampleImage}");
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SpecificEventUi(
                                  eventId: event.name,
                                  date: DateFormat('dd-MM-yyyy')
                                      .format(event.date),
                                )));
                  },
                  child: EventCard(
                    imageUrl:
                        "http://3.82.180.105:8000/api${event.sampleImage}",
                    title: event.name,
                    imageCount: event.imageCount,
                    date: DateFormat('dd-MM-yyyy').format(event.date),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int imageCount;
  final String date;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.imageCount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      width: double.infinity,
      height: 200,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 138,
              height: 176,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '$imageCount',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/images_icon.png',
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
                Gap(10),
                Expanded(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    date,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
