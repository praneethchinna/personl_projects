import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/models/faq_model.dart';

class HelpRepository {
  final Dio dio;
  final Ref ref;

  HelpRepository({required this.dio, required this.ref});

  Future<FaqResponse> getFaqs() async {
    try {
      final response = await dio.get('/help/faqs/');
      
      if (response.statusCode == 200) {
        return FaqResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load FAQs');
      }
    } on DioException catch (e) {
      // For demo purposes, return sample data if API fails
      if (e.response?.statusCode == 404) {
        return _getSampleFaqs();
      }
      throw Exception('Error fetching FAQs: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Fallback sample data
  FaqResponse _getSampleFaqs() {
    return FaqResponse(

      faqs: [
        FaqModel(
          id: 1,
          question: "How do I join the We YSRCP app?",
          answer: "Be a proud supporter of YSR Congress Party by signing up with your Gmail account or phone number. Just complete your profile and verify your mobile with an OTP — and you're in!",
        ),
        FaqModel(
          id: 2,
          question: "Why should I use We YSRCP daily?",
          answer: "This app is your digital gateway to support our party's mission, access authentic news, highlight government achievements, and counter false narratives from opposition. Your voice and time here earn you recognition and rewards.",
        ),
        FaqModel(
          id: 3,
          question: "What details are needed while signing up?",
          answer: "We ask for your name, gender, state, parliament, constituency, and a verified mobile number. Email is optional if you sign in using Gmail.",
        ),
      ],
    );
  }
}
