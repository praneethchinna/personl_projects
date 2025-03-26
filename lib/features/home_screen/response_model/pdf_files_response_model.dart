class PdfFilesResponseModel {
  int id;
  String pdfName;
  String pdfPath;
  String pdfTypeName;
  int createdBy;
  DateTime createdAt;

  PdfFilesResponseModel({
    required this.id,
    required this.pdfName,
    required this.pdfPath,
    required this.pdfTypeName,
    required this.createdBy,
    required this.createdAt,
  });

  factory PdfFilesResponseModel.fromJson(Map<String, dynamic> json) {
    return PdfFilesResponseModel(
      id: json['id'],
      pdfName: json['pdf_name'],
      pdfPath: json['pdf_path'],
      pdfTypeName: json['pdf_type_name'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pdfName': pdfName,
      'pdfPath': pdfPath,
      'pdfTypeName': pdfTypeName,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
