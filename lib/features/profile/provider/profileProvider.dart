import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/profile/repo/profile_repo.dart';
import 'package:ysr_project/features/profile/response_model/profile_response_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

final profileAsyncProvider = FutureProvider.family
    .autoDispose<ProfileResponseModel, String>((ref, phoneNumber) async {
  final dio = ref.read(dioProvider);
  return ProfileRepo(dio: dio, ref: ref).getProfileData(phoneNumber);
});
