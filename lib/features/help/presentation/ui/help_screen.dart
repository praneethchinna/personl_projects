import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ysr_project/colors/app_colors.dart';
import 'package:ysr_project/core_widgets/ysr_app_bar.dart';

import '../../domain/models/faq_model.dart';
import '../providers/help_provider.dart';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsFutureProvider);
    final expandedFaqId = ref.watch(expandedFaqProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: YsrAppBar(
        title: const Text(
          'Help & FAQs',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: faqsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load FAQs'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(faqsFutureProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (faqResponse) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Find answers to common questions about using the app.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                      ),
                      Gap(10),
                    ],
                  ),
                ),
                ...faqResponse.faqs.map((faq) {
                  final isExpanded = faq.id == expandedFaqId;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FaqItem(
                        faq: faq,
                        isExpanded: isExpanded,
                        onTap: () {
                          ref.read(expandedFaqProvider.notifier).state =
                              isExpanded ? null : faq.id;
                        },
                      ),
                      Divider(
                        indent: 20,
                      )
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final FaqModel faq;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqItem({
    Key? key,
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.help, color: AppColors.primaryColor),
            title: Text(
              faq.question,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primaryColor,
            ),
            onTap: onTap,
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Text(
                faq.answer,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ),
        ],
      ),
    );
  }
}
