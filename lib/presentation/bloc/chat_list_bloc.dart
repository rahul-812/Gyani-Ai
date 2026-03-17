import 'package:flutter/material.dart';
import 'package:flutter_ai/data/gemini_api.dart';
import 'package:flutter_ai/domain/entity/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatEvent, ChatListState> {
  final GeminiApi _api;

  ChatListBloc(this._api) : super(const ChatListState()) {
    on<ChatAdd>((event, emit) {
      if (state.chats.isNotEmpty && state.responseStete is ResponseError) {
        state.chats.removeLast();
      }

      final newChat = event.chat;
      final updatedChats = [...state.chats, newChat];

      if (newChat.isUser) {
        final stream = _api.generateContent(state.chats, newChat.text);

        emit(
          state.copyWith(
            chats: updatedChats,
            responseStete: ResponseStreamming(stream),
          ),
        );
      } else {
        emit(
          state.copyWith(
            chats: updatedChats,
            responseStete: const ResponseInitial(),
          ),
        );
      }
    });
    // ChatListBloc(this._api) : super(const ChatListState()) {
    //   on<ChatListAdd>((event, emit) {
    //     final newChat = event.chat;
    //     final updatedChats = [...state.chats, newChat];

    //     if (newChat.isUser) {
    //       final stream = _api.generateContent(
    //         state.chats,
    //         newChat.text,
    //       );

    //       emit(state.copyWith(chats: updatedChats, stream: stream));
    //     } else {
    //       emit(state.copyWith(chats: updatedChats, clearStream: true));
    //     }
    //   });

    on<ChatError>((event, emit) {
      emit(
        state.copyWith(
          responseStete: ResponseError(event.error),
        ),
      );
    });
  }
}
