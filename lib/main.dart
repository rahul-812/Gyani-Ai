import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai/data/gemini_api.dart';
import 'package:flutter_ai/firebase_options.dart';
import 'package:flutter_ai/presentation/bloc/chat_list_bloc.dart';
import 'package:flutter_ai/presentation/pages/chat_page.dart';
import 'package:flutter_ai/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      title: "Gyani Ai",
      home: BlocProvider(
        create: (context) => ChatListBloc(GeminiApiImpl()),
        child: const ChatPage(),
      ),
    );
  }
}
