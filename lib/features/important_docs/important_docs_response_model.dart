class ImportantDocsResponse {
  final List<ImportantDocFile> files;
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final bool hasNext;

  ImportantDocsResponse({
    required this.files,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
  });

  factory ImportantDocsResponse.fromJson(Map<String, dynamic> json) {
    return ImportantDocsResponse(
      files: (json['files'] as List<dynamic>?)?.isNotEmpty == true
          ? (json['files'] as List<dynamic>)
              .map((e) => ImportantDocFile.fromJson(e))
              .toList()
          : (json['saved_pdfs'] as List<dynamic>?)?.isNotEmpty == true
              ? (json['saved_pdfs'] as List<dynamic>)
                  .map((e) => ImportantDocFile.fromJson(e))
                  .toList()
              : [],
      totalCount: json['total_count'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      hasNext: json['has_next'] ?? false,
    );
  }
}

class ImportantDocFile {
  final int id;
  final String pdfName;
  final String pdfPath;
  final String pdfTypeName;
  final int createdBy;
  final String createdAt;
  final bool isSaved;

  ImportantDocFile({
    required this.id,
    required this.pdfName,
    required this.pdfPath,
    required this.pdfTypeName,
    required this.createdBy,
    required this.createdAt,
    required this.isSaved,
  });

  factory ImportantDocFile.fromJson(Map<String, dynamic> json) {
    return ImportantDocFile(
      id: json['id'] ?? 0,
      pdfName: json['pdf_name'] ?? '',
      pdfPath: json['pdf_path'] ?? '',
      pdfTypeName: json['pdf_type_name'] ?? '',
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] ?? '',
      isSaved: json['is_saved'] ?? true,
    );
  }
}
