import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ysr_project/services/notification_service/flutter_local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = getToken(); // Get FCM token
    LocalNotification().init(); // Initialize local notifications
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase Token Example')),
        body: FutureBuilder<String?>(
          future: _tokenFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Token: ${snapshot.data ?? "No token found"}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      // sendNotification(),
                      child: const Text("Send notification"),
                      onPressed: () async {},
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<String?> getToken() async {
    // Request notification permission
    await FirebaseMessaging.instance.requestPermission();

    // Get FCM token
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      log('Token: $token');
      // Optional: Register device token with your backend
      // await registerDevice(token);
    } else {
      log('Failed to get token');
    }
    return token;
  }
}
