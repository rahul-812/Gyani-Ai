part of 'chat_list_bloc.dart';

@immutable
sealed class ResponseState {
  const ResponseState();
}

final class ResponseInitial extends ResponseState {
  const ResponseInitial();
}

final class ResponseStreamming extends ResponseState {
  final Stream<String> stream;
  const ResponseStreamming(this.stream);
}

final class ResponseSuccess extends ResponseState {
  final Chat chat;
  const ResponseSuccess(this.chat);
}

final class ResponseError extends ResponseState {
  final String error;
  const ResponseError(this.error);
}

// @immutable
// class ChatListState {
//   final List<Chat> chats;
//   final Stream<String>? stream;

//   const ChatListState({this.chats = const [], this.stream});

//   ChatListState copyWith({
//     List<Chat>? chats,
//     Stream<String>? stream,
//     bool clearStream = false, // 👈 Add this flag
//   }) {
//     return ChatListState(
//       chats: chats ?? this.chats,
//       stream: clearStream ? null : (stream ?? this.stream),
//     );
//   }

//   bool get isStreamming => stream != null;
// }

@immutable
class ChatListState {
  final List<Chat> chats;
  final ResponseState responseStete;

  const ChatListState({
    this.chats = const [],
    this.responseStete = const ResponseInitial(),
  });

  ChatListState copyWith({List<Chat>? chats, ResponseState? responseStete}) {
    return ChatListState(
      chats: chats ?? this.chats,
      responseStete: responseStete ?? this.responseStete,
    );
  }

  bool get isStreamming => responseStete is ResponseStreamming;
}
