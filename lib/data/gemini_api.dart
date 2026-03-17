import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_ai/domain/entity/chat.dart';
import 'package:flutter_ai/error/ai_exception.dart';

abstract interface class GeminiApi {
  Stream<String> generateContent(List<Chat> messageHistory, String newMessage);
}

class GeminiApiImpl implements GeminiApi {
  late final GenerativeModel _model;

  GeminiApiImpl()
    : _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        systemInstruction: Content.system(
          "Helpful AI assistant, Gen-Z tone, a few emojis. Reply format: 1. brief compliment, 2. concise info-dense answer, 3. 2-3 related follow-up suggestions.",
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

    try {
      final responseStream = _model.generateContentStream(prompt);

      await for (final chunk in responseStream) {
        final textPart = chunk.text;
        // If textPart is null, it might be a metadata chunk or the end of the stream.
        // We skip it and continue processing subsequent chunks if any.
        if (textPart == null) continue;
        buffer.write(textPart);
        yield buffer.toString();
      }
    } on FirebaseAIException catch (e) {
      throw AiException(e.message);
    } catch (e) {
      throw AiException(e.toString());
    }
  }
}
