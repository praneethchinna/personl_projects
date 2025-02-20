import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/polls/providers/polls_provider.dart';
import 'package:ysr_project/features/polls/repository/polls_respository_impl.dart';
import 'package:ysr_project/features/polls/widgets/poll_widget.dart';

class PollScreen extends ConsumerStatefulWidget {
  const PollScreen({super.key});

  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends ConsumerState<PollScreen> {
  @override
  Widget build(BuildContext context) {
    final notifer = ref.watch(pollsProvider.notifier);
    final state = ref.watch(pollsProvider);
    return switch (true) {
      _ when state.isLoading =>
        const Center(child: CircularProgressIndicator.adaptive()),
      _ when state.isError.isNotEmpty =>
        const Center(child: Text("Something went wrong")),
      _ => RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(pollsProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: state.polls.length,
            itemBuilder: (context, index) {
              final poll = state.polls[index];
              return PollWidget(votes: poll.votes,
                  enableSubmit: !poll.enableSubmit,
                  onSubmit: () {
                    ref
                        .read(pollsRepositoryProvider)
                        .submitVote(poll.id, poll.selectedOption!)
                        .then((value) {
                      EasyLoading.show();
                      if (value) {
                        EasyLoading.dismiss();
                        ref.invalidate(pollsProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Submitted sucessfully'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Not submitted something went wrong'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }).catchError((e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Something went wrong'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }).whenComplete(() {
                      EasyLoading.dismiss();
                    });
                  },
                  title: "WeYSRCP",
                  question: poll.question,
                  options: poll.options,
                  onOptionSelected: (selectedOption) {
                    notifer.updateSelectedIndex(index, selectedOption);
                  },
                  selectedOption: poll.selectedOption,
                  createdAt: poll.createdAt);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
        ),
    };
  }
}
