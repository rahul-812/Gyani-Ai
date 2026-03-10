import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai/presentation/pages/chat_page.dart';
import 'package:flutter_ai/firebase_options.dart';
import 'package:flutter_ai/theme/theme.dart';

Future<void> setUpApp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: "Firebase Ai",
      home: const ChatPage(),
    );
  }
}
