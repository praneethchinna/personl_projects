import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';
import 'package:ysr_project/features/important_docs/important_docs_notifier.dart';
import 'package:ysr_project/features/important_docs/important_docs_repo.dart';
import 'package:ysr_project/features/important_docs/utils/pdf_tile.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

final docsNameProvider = StateProvider<String>((ref) => "All");

class ImportantDocsUi extends ConsumerStatefulWidget {
  const ImportantDocsUi({super.key});

  @override
  ConsumerState<ImportantDocsUi> createState() => _ImportantDocsUiState();
}

class _ImportantDocsUiState extends ConsumerState<ImportantDocsUi> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingNextPage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingNextPage) {
      final notifier = ref.read(importantDocsAsyncNotifierProvider.notifier);
      final state = ref.read(importantDocsAsyncNotifierProvider);
      if (state is AsyncData && state.value!.hasNext) {
        setState(() {
          _isFetchingNextPage = true;
        });
        final value = ref.read(docsNameProvider);
        await notifier
            .fetchNextPage(value.toLowerCase() == "saved" ? "value" : null);
        setState(() {
          _isFetchingNextPage = false;
        });
      }
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

  Widget _buildPdfTile() {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final importantDocsNotifier = ref.watch(importantDocsAsyncNotifierProvider);
    final notifier = ref.read(importantDocsAsyncNotifierProvider.notifier);
    final userId = ref.read(userProvider).userId;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: YsrAppBar(
          centerTitle: true,
          title: Text(
            ref.watch(docsNameProvider),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: 5, right: 2, top: 5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                height: MediaQuery.of(context).size.height - 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref.read(docsNameProvider.notifier).state = "Saved";
                          notifier.fetchSavedDocs(userId.toString());
                        },
                        child: FolderCard(
                          currentSelected:
                              ref.watch(docsNameProvider) == "Saved",
                          iconPath: "assets/save_icon.png",
                          label: 'Saved Docs',
                          backgroundColor: Colors.white,
                          arrowRight: true,
                          arrowColor: Colors.blue,
                        ),
                      ),
                      Gap(10),
                      GestureDetector(
                        onTap: () {
                          ref.read(docsNameProvider.notifier).state = "All";
                          setState(() {
                            notifier.fetchDocsByType(null);
                          });
                        },
                        child: FolderCard(
                          currentSelected: ref.watch(docsNameProvider) == "All",
                          iconPath: "assets/all_doc_icon.png",
                          label: 'All',
                          backgroundColor: Colors.white,
                          arrowRight: true,
                          arrowColor: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          ref.read(docsNameProvider.notifier).state = ""
                              "Social Media Magazines";
                          setState(() {
                            notifier.fetchDocsByType("Social Media Magazine");
                          });
                        },
                        child: FolderCard(
                          arrowColor: Colors.yellow,
                          currentSelected: ref.watch(docsNameProvider) ==
                              "Social Media Magazines",
                          iconPath: "assets/social_media_magazines.png",
                          label: 'Social Media Magazines',
                          backgroundColor: Colors.white,
                          arrowRight: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          ref.read(docsNameProvider.notifier).state =
                              "Daily Party Paper Praja Sankalpam";
                          setState(() {
                            notifier.fetchDocsByType(
                                "Daily Party Paper Praja Sankalpam");
                          });
                        },
                        child: FolderCard(
                          arrowColor: Colors.red,
                          currentSelected: ref.watch(docsNameProvider) ==
                              "Daily Party Paper Praja Sankalpam",
                          iconPath: "assets/daily_praja_sankalpam_icon.png",
                          label: 'Daily Praja Sankalpam',
                          backgroundColor: Colors.white,
                          arrowRight: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          ref.read(docsNameProvider.notifier).state = "Others";
                          setState(() {
                            notifier.fetchDocsByType("Others");
                          });
                        },
                        child: FolderCard(
                          arrowColor: Colors.blueAccent,
                          currentSelected:
                              ref.watch(docsNameProvider) == "Others",
                          iconPath: "assets/others_doc_icon.png",
                          label: 'Others',
                          backgroundColor: Colors.white,
                          arrowRight: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          ref.read(docsNameProvider.notifier).state =
                              "Important Data";
                          setState(() {
                            notifier.fetchDocsByType("Important Data");
                          });
                        },
                        child: FolderCard(
                          arrowColor: Colors.blue,
                          currentSelected:
                              ref.watch(docsNameProvider) == "Important Data",
                          iconPath: 'assets/important_data_icon.png',
                          label: 'Important Data',
                          backgroundColor: Colors.white,
                          arrowRight: true,
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 2, right: 5, top: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              height: MediaQuery.of(context).size.height - 100,
              child: importantDocsNotifier.when(
                data: (state) {
                  if (state.documents.isEmpty) {
                    return Center(child: Text('No documents found.'));
                  }
                  return Stack(
                    children: [
                      ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          endIndent: 10,
                          indent: 10,
                          height: 0.5,
                        ),
                        controller: _scrollController,
                        itemCount: state.documents.length,
                        itemBuilder: (context, index) {
                          final doc = state.documents[index];
                          return PdfTile(
                            url: doc.pdfPath,
                            isBookmarked: doc.isSaved,
                            title: doc.pdfName,
                            date: formatDate(doc.createdAt),
                            onShare: () {},
                            onBookmark: () async {
                              final repo =
                                  ImportantDocsRepo(dio: ref.read(dioProvider));
                              EasyLoading.show();
                              final userDetails = ref.read(userProvider);

                              await repo
                                  .savePDF(doc.id, userDetails.userId,
                                      userDetails.name)
                                  .then((value) {
                                EasyLoading.dismiss();
                                if (value) {
                                  switch (ref.read(docsNameProvider)) {
                                    case "All":
                                      notifier.fetchDocsByType(null);
                                      break;
                                    case "Saved":
                                      notifier
                                          .fetchSavedDocs(userId.toString());
                                      break;
                                    default:
                                      notifier.fetchDocsByType(
                                          ref.read(docsNameProvider));
                                      break;
                                  }
                                } else {
                                  EasyLoading.showError("Failed");
                                }
                              }, onError: (error, stackTrace) {
                                EasyLoading.dismiss();
                                EasyLoading.showError(error.toString());
                              });
                            },
                            onTap: () {
                              ShareCard(title: doc.pdfName, link: doc.pdfPath)
                                  .launchURL(context);
                            },
                          );
                        },
                      ),
                      if (_isFetchingNextPage)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                loading: () =>
                    Center(child: CircularProgressIndicator.adaptive()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            )),
          ],
        ));
  }
}

class FolderCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool currentSelected;
  final Color backgroundColor;
  final Color arrowColor;
  final bool arrowRight; // Change arrow direction

  const FolderCard({
    super.key,
    required this.iconPath,
    required this.currentSelected,
    required this.label,
    this.backgroundColor = const Color(0xFFF6F6F6),
    this.arrowColor = const Color(0xFFE8DDF9),
    this.arrowRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 90,
          width: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                currentSelected ? arrowColor.withOpacity(0.2) : backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFFEDF0F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: 30,
                height: 30,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ArrowRight extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const ArrowRight({
    super.key,
    this.width = 100,
    this.height = 140,
    this.color = const Color(0xFFEBD8F1), // Default light purple
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _RightArrowClipper(),
      child: Container(
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}

class _RightArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RightTriangle extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const RightTriangle({
    super.key,
    this.color = Colors.purple,
    this.width = 50,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _RightTrianglePainter(color.withOpacity(0.2)),
    );
  }
}

class _RightTrianglePainter extends CustomPainter {
  final Color color;

  _RightTrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
