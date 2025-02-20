import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/login/repository/login_repository_impl.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';

final repoProvider = Provider<LoginRepositoryImpl>((ref) {
  final dio = ref.read(dioProvider);
  return LoginRepositoryImpl(dio: dio, ref: ref);
});
