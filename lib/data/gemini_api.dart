import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_ai/domain/entity/chat.dart';

abstract interface class GeminiApi {
  Stream<String> generateContent(
    List<Chat> messageHistory,
    String newMessage,
  );
}

class GeminiApiImpl implements GeminiApi {
  late final GenerativeModel _model;

  GeminiApiImpl()
    : _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        systemInstruction: Content.system(
          "You are a helpfull Ai Assistant. Understand conversations and reply user in a Gen-Z tone. Use few emojies but don't overuse.",
        ),
      );

  @override
  Stream<String> generateContent(
    List<Chat> messageHistory,
    String newMessage,
  ) async* {
    final prompt = <Content>[];

    for (final message in messageHistory) {
      if (message.text.isNotEmpty) {
        if (message.isUser) {
          // Explicitly giving the role as 'user'
          prompt.add(Content('user', [TextPart(message.text)]));
        } else {
          // Explicitly giving the role as 'model'
          prompt.add(Content('model', [TextPart(message.text)]));
        }
      }
    }

    // Role 'user' is the default for input prompts
    prompt.add(Content('user', [TextPart(newMessage)]));

    final buffer = StringBuffer();

    final responseStream = _model.generateContentStream(prompt);

    await for (final chunk in responseStream) {
      final textPart = chunk.text;
      if (textPart == null) {
        throw Exception("Unable to proceed your response this time.");
      }

      buffer.write(chunk.text);
      yield buffer.toString();
    }
  }
}
