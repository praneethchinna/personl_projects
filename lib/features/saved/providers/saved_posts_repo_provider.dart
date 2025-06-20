import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/saved/repository/saved_posts_repo_impl.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

final savedPostsRepoProvider = Provider<SavedPostsRepoImpl>((ref) {
  final dio = ref.read(dioProvider);
  return SavedPostsRepoImpl(dio: dio, ref: ref);
});


