class GrievanceCategoryResponseModel {
  final int categoryId;
  final String categoryName;

  GrievanceCategoryResponseModel({
    required this.categoryId,
    required this.categoryName,
  });

  factory GrievanceCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return GrievanceCategoryResponseModel(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }
}
