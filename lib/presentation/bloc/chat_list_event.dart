part of 'chat_list_bloc.dart';

@immutable
sealed class ChatEvent {
  const ChatEvent();
}

class ChatAdd extends ChatEvent {
  final Chat chat;

  const ChatAdd({required this.chat});
}

class ChatError extends ChatEvent {
  final String error;
  const ChatError(this.error);
}
