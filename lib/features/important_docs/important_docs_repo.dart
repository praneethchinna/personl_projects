import 'package:dio/dio.dart';
import 'package:ysr_project/features/important_docs/important_docs_response_model.dart';

class ImportantDocsRepo {
  final Dio dio;
  ImportantDocsRepo({required this.dio});

  Future<ImportantDocsResponse> getImportantDocs(
      {String? pdfType, int page = 1, required int userId}) async {
    try {
      final queryParams = <String, dynamic>{'page': page, "user_id": userId};
      if (pdfType != null && pdfType.isNotEmpty) {
        queryParams['pdf_type_name'] = pdfType;
      }
      final response =
          await dio.get('/list-pdfs', queryParameters: queryParams);
      return ImportantDocsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch important docs: $e');
    }
  }

  Future<ImportantDocsResponse> getSavedDocsByUser(
      {required String userId, int page = 1}) async {
    try {
      final response = await dio.get(
          '/pdf/saved-by-user/${int.tryParse(userId.toString()) ?? 1}?page=$page');
      if (response.statusCode == 200) {
        return ImportantDocsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch saved docs');
      }
    } catch (e) {
      throw Exception('Failed to fetch saved docs: $e');
    }
  }

  Future<bool> savePDF(int pdfId, int userId, String userName) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'user_name': userName,
        'id': pdfId,
      });
      final response = await dio.post('/pdf/save',
          data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to save pdf');
      }
    } catch (e) {
      throw Exception('Failed to save pdf: $e');
    }
  }
}
