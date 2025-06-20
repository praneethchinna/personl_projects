import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ysr_project/core_widgets/demo_file.dart';

void main() {
  runApp(
    ProviderScope(child: const MaterialApp(home: MyWidget())),
  );
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(getNameProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
            Text("${ref.watch(myStateNotifierProvider)}"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(myStateNotifierProvider.notifier).increment();
              },
              child: Text("Increment"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(myStateNotifierProvider.notifier).decrement();
              },
              child: Text("Decrement"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ref.watch(myAddressProvider).when(data: (data) {
                return Text("Address: ${data.street}, ${data.city}");
              }, error: (e, s) {
                return Text("Error: $e");
              }, loading: () {
                return LinearProgressIndicator();
              }),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Street',
              ),
              onChanged: (value) {
                ref.read(myAddressProvider.notifier).updateStreet(value);
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'City',
              ),
              onChanged: (value) {
                ref.read(myAddressProvider.notifier).updateCity(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
