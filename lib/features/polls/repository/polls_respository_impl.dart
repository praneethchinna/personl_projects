import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/polls/response_models/submitted_polls_list.dart';
import 'package:ysr_project/features/polls/response_models/user_polls_response_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';
import 'package:ysr_project/services/user/user_data.dart';

class PollsRepositoryImpl {
  final Dio dio;
  final Ref ref;

  PollsRepositoryImpl({required this.dio, required this.ref});

  Future<UserPollsResponseModel> getUserPolls() async {
    final userId = ref.read(userProvider).userId;
    try {
      final response = await dio.get('/polls/list/?user_id=$userId');

      if (response.statusCode == 200) {
        return UserPollsResponseModel.fromJson(response.data);
      } else if (response.statusCode == 422) {
        return throw Exception("Failed to get polls");
      }
      return throw Exception("Failed to get polls");
    } catch (e) {
      return throw Exception("Failed to get polls");
    }
  }

  Future<bool> submitVote(int pollId, String option) async {
    final userId = ref.read(userProvider).userId;
    final userName = ref.read(userProvider).name;
    try {
      final Dio dioInstance = Dio();
      final response = await dioInstance
          .post('http://3.82.180.105:8000/api/polls/vote/', data: {
        "poll_id": pollId,
        "option": option,
        "user_id": userId,
        "user_name": userName
      });
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 500) {
        return throw Exception("Vote already submitted");
      }
      return throw Exception("Failed to submit vote");
    } catch (e) {
      return throw Exception("Failed to submit vote");
    }
  }

  Future<SubmittedPollsResponseModel> getSubmittedPolls() async {
    final userId = ref.read(userProvider).userId;
    try {
      final response = await dio.get('/polls/votes/?user_id=$userId');
      if (response.statusCode == 200) {
        return SubmittedPollsResponseModel.fromJson(response.data);
      } else if (response.statusCode == 422) {
        return throw Exception("Failed to get submitted polls");
      }
      return throw Exception("Failed to get submitted polls");
    } catch (e) {
      return throw Exception("Failed to get submitted polls");
    }
  }
}

final pollsRepositoryProvider = Provider<PollsRepositoryImpl>((ref) {
  return PollsRepositoryImpl(dio: ref.read(dioProvider), ref: ref);
});
