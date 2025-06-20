import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/gallery/providers/gallary_providers.dart';
import 'package:ysr_project/features/gallery/providers/gallery_specific_event_provider.dart';
import 'package:ysr_project/features/gallery/ui/gallery_summary_ui.dart';
import 'package:ysr_project/features/gallery/view_model/gallery_view_model.dart';
import 'package:ysr_project/features/helper/download_multiple_file.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  final Set<String> selectedImages = {}; // Track selected images

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(galleryNotifierProvider.notifier);
    final viewModel = ref.watch(galleryNotifierProvider);

    return Scaffold(
      appBar: YsrAppBar(
        title: Text("gallery".tr(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        centerTitle: true,
      ),
      body: switch (true) {
        _ when viewModel.isLoading =>
          Center(child: CircularProgressIndicator.adaptive()),
        _ when viewModel.isError.isNotEmpty =>
          Center(child: Text(viewModel.isError)),
        _ => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: viewModel.eventName.isNotEmpty
                              ? viewModel.eventName
                              : null,
                          hint: const Text(
                            "Select Event",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (String? newValue) {
                            notifier.updateEvent(newValue!);
                            setState(() {
                              selectedImages.clear();
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.black87),
                          iconSize: 28,
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                          items: viewModel.eventsResponseModel.events
                              .map((category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              viewModel.eventName != "Select Events"
                  ? Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: viewModel.galleryResponseModel.images.length,
                        itemBuilder: (context, index) {
                          final items =
                              viewModel.galleryResponseModel.images[index];
                          final imageUrl =
                              "http://3.82.180.105:8000/api${items.url}";
                          final isSelected = selectedImages.contains(imageUrl);

                          return GestureDetector(
                            onLongPress: () {
                              setState(() {
                                if (isSelected) {
                                  selectedImages.remove(imageUrl);
                                } else {
                                  selectedImages.add(imageUrl);
                                }
                              });
                            },
                            onTap: () {
                              if (selectedImages.isNotEmpty) {
                                setState(() {
                                  if (isSelected) {
                                    selectedImages.remove(imageUrl);
                                  } else {
                                    selectedImages.add(imageUrl);
                                  }
                                });
                              } else {
                                // Open full-screen image if no selection mode is active
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenGalleryView(
                                      imageUrls: viewModel
                                          .galleryResponseModel.images
                                          .map((e) =>
                                              "http://3.82.180.105:8000/api${e.url}")
                                          .toList(),
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Stack(
                              children: [
                                Hero(
                                  tag: imageUrl,
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.check_circle_rounded,
                                            color: Colors.blue, size: 30)),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(child: GallerySummaryPage())
            ],
          ),
      },
      floatingActionButton: selectedImages.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await _downloadImages();
              },
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.download, color: Colors.white),
            )
          : null,
    );
  }

  Future<void> _downloadImages() async {
    await HelperDownloadFiles.downloadMultipleFiles(
        selectedImages.toList(), context);
    setState(() {
      selectedImages.clear();
    });
  }
}

class FullScreenGalleryView extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final PageController _pageController;

  FullScreenGalleryView({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  }) : _pageController = PageController(initialPage: initialIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            onPressed: () {
              final currentImage =
                  imageUrls[_pageController.page?.round() ?? 0];
              HelperDownloadFiles.downloadMultipleFiles(
                  [currentImage], context);
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 5.0,
              child: Hero(
                tag: imageUrls[index],
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GalleryWidget extends ConsumerStatefulWidget {
  final GalleryImageNotifier galleryImageNotifier;
  final Function functionality;
  final GalleryViewModel viewModel;
  const GalleryWidget(
      {required this.functionality,
      super.key,
      required this.viewModel,
      required this.galleryImageNotifier});

  @override
  ConsumerState<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends ConsumerState<GalleryWidget> {
  final Set<String> selectedImages = {};
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return Scaffold(
      appBar: null,
      body: LazyLoadScrollView(
        onEndOfPage: () {
          widget.galleryImageNotifier.loadMoreImages();
        },
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: viewModel.galleryResponseModel.images.length,
          itemBuilder: (context, index) {
            final items = viewModel.galleryResponseModel.images[index];
            final imageUrl = "http://3.82.180.105:8000/api${items.url}";
            final isSelected = selectedImages.contains(imageUrl);

            return GestureDetector(
              onLongPress: () {
                setState(() {
                  if (isSelected) {
                    selectedImages.remove(imageUrl);
                  } else {
                    selectedImages.add(imageUrl);
                  }
                });
              },
              onTap: () {
                if (selectedImages.isNotEmpty) {
                  setState(() {
                    if (isSelected) {
                      selectedImages.remove(imageUrl);
                    } else {
                      selectedImages.add(imageUrl);
                    }
                  });
                } else {
                  // Open full-screen image if no selection mode is active
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenGalleryView(
                        imageUrls: viewModel.galleryResponseModel.images
                            .map((e) => "http://3.82.180.105:8000/api${e.url}")
                            .toList(),
                        initialIndex: index,
                      ),
                    ),
                  );
                }
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Hero(
                      tag: imageUrl,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.check_circle_rounded,
                              color: Colors.blue, size: 30)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: selectedImages.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await _downloadImages();
              },
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.download, color: Colors.white),
            )
          : null,
    );
  }

  Future<void> _downloadImages() async {
    await HelperDownloadFiles.downloadMultipleFiles(
        selectedImages.toList(), context);
    setState(() {
      selectedImages.clear();
    });
  }
}
