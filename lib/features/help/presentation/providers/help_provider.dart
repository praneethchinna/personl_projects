import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/features/help/data/repository/help_repository.dart';
import 'package:ysr_project/features/help/domain/models/faq_model.dart';
import 'package:ysr_project/services/http_networks/dio_provider.dart';


final helpRepositoryProvider = Provider<HelpRepository>((ref) {
  final dio = ref.read(dioProvider);
  return HelpRepository(dio: dio, ref: ref);
});

final faqsFutureProvider = FutureProvider.autoDispose<FaqResponse>((ref) async {
  final repository = ref.read(helpRepositoryProvider);
  return repository.getFaqs();
});

final expandedFaqProvider = StateProvider<int?>((ref) => null);
