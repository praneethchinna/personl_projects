import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/gallery/providers/gallary_providers.dart';
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Gallery", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: switch (true) {
        _ when viewModel.isLoading =>
          Center(child: CircularProgressIndicator.adaptive()),
        _ when viewModel.isError.isNotEmpty =>
          Center(child: Text(viewModel.isError)),
        _ => Column(
            children: [
              Gap(20),
              Row(
                children: [
                  Gap(10),
                  Text(
                    "Select the events: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: viewModel.eventName,
                          onChanged: (String? newValue) {
                            notifier.updateEvent(newValue!);
                            setState(() {
                              selectedImages
                                  .clear(); // Reset selections when category changes
                            });
                          },
                          items: viewModel.eventsResponseModel.events
                              .map((category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(
                                category.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                          // icon: Icon(
                          //   Icons.keyboard_arrow_down,
                          //   color: AppColors.primaryColor,
                          // ),
                          // iconSize: 24,
                          // underline: Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(20),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
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
                              builder: (context) =>
                                  FullScreenImage(imageUrl: imageUrl),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: imageUrl,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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

// Full-Screen Image View
class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({super.key, required this.imageUrl});

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
              HelperDownloadFiles.downloadMultipleFiles([imageUrl], context);
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1.0, // Default scale
          maxScale: 5.0,
          child: Hero(
            tag: imageUrl,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
