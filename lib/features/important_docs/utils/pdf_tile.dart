import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/features/home_screen/helper_class/file_share_helper.dart';

class PdfTile extends StatelessWidget {
  final String url;
  final bool isBookmarked;
  final String title;
  final String date;
  final VoidCallback onShare;
  final VoidCallback onBookmark;
  final VoidCallback onTap;

  const PdfTile({
    super.key,
    required this.url,
    required this.title,
    required this.date,
    required this.onShare,
    required this.onBookmark,
    required this.onTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            "assets/pdf_icon.png",
            width: 25,
            height: 25,
          ),
          const Gap(5),
          GestureDetector(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Gap(5),
                Text(
                  date,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onBookmark,
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.blue,
                  size: 25,
                ),
              ),
              Gap(15),
              GestureDetector(
                onTap: () async {
                  await FileShareHelper()
                      .shareFiles([url], "check this pdf file");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Share",
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        MdiIcons.share,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
