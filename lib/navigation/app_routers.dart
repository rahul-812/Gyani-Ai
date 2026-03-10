import 'package:flutter_ai/presentation/pages/chat_page.dart';
import 'package:go_router/go_router.dart';

GoRouter buildAppRouter() => GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const ChatPage())],
);

