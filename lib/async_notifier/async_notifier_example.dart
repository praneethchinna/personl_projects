import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final numberAsyncNotifierProvider =
    AsyncNotifierProvider<NumberProvider, int>(NumberProvider.new);

class NumberProvider extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() async {
    await Future.delayed(Duration(seconds: 2));
    return 100;
  }
}

void main() {
  runApp(
    ProviderScope(
        child: MaterialApp(
      home: MyApp(),
    )),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = ref.watch(numberAsyncNotifierProvider);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: number.when(
            data: (data) => Text(data.toString()),
            loading: () => CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
          ),
        ),
      ),
    );
  }
}
