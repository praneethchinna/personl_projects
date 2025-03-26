import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';
import 'package:ysr_project/features/home_screen/response_model/pdf_files_response_model.dart';
import 'package:ysr_project/features/home_screen/ui/notifications_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PdfListWidget extends ConsumerStatefulWidget {
  const PdfListWidget({super.key});

  @override
  _PdfListWidgetState createState() => _PdfListWidgetState();
}

class _PdfListWidgetState extends ConsumerState<PdfListWidget> {
  List<PdfFilesResponseModel> _future = [];
  List<PdfFilesResponseModel> temp = [];
  bool isLoading = true;
  String error = '';
  String selectedValue = "All";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    getPdfFiles();
  }

  Future<void> getPdfFiles() async {
    try {
      _future = await ref.read(pdfFilesProvider.future);
      temp = List.of(_future);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          error = e.toString();
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        applyFilters();
      });
    }
  }

  void applyFilters() {
    temp = _future.where((pdf) {
      bool matchesType = selectedValue == "All" ||
          pdf.pdfTypeName.toLowerCase() == selectedValue.toLowerCase();

      // If "All" is selected, do not filter by date
      bool matchesDate = selectedValue == "All" ||
          (selectedDate == null ||
              DateFormat('dd MMM yyyy').format(pdf.createdAt) ==
                  DateFormat('dd MMM yyyy').format(selectedDate!));

      return matchesType && matchesDate;
    }).toList();

    // Sort by date (newest first)
    temp.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text('Important PDF Documents'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // **Dropdown for filtering by PDF type**
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedValue,
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.black54),
                                    isExpanded: true,
                                    items: [
                                      "Daily Party Paper Praja Sankalpam",
                                      "Important Data",
                                      "Social Media Magazine",
                                      "Others",
                                      "All"
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedValue = value;
                                          applyFilters();
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Gap(20),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedDate == null
                                            ? "Select Date"
                                            : DateFormat('dd MMM yyyy')
                                                .format(selectedDate!),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: const Icon(Icons.calendar_today,
                                            color: Colors.black54, size: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(20),

                      // **List of Filtered PDFs**
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: temp.length,
                        itemBuilder: (context, index) {
                          final pdf = temp[index];
                          final createdAt =
                              DateFormat('dd MMM yyyy').format(pdf.createdAt);

                          return ListTile(
                            onTap: () {
                              ShareCard(title: pdf.pdfName, link: pdf.pdfPath)
                                  .launchURL(context);
                            },
                            leading: const Icon(
                              FontAwesomeIcons.solidFilePdf,
                              color: Colors.deepOrangeAccent,
                              size: 40,
                            ),
                            title: Text(pdf.pdfName),
                            subtitle: Text(createdAt),
                            trailing: IconButton(
                              onPressed: () {
                                ShareCard(title: pdf.pdfName, link: pdf.pdfPath)
                                    .shareOnSocialMedia(context, "",
                                        sharetext: "check Pdf from WeYSRCP");
                              },
                              icon:
                                  const Icon(FontAwesomeIcons.shareFromSquare),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
