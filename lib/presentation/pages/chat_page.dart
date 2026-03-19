import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ai/domain/entity/chat.dart';
import 'package:flutter_ai/error/ai_exception.dart';
import 'package:flutter_ai/presentation/bloc/chat_list_bloc.dart';
import 'package:flutter_ai/theme/constants.dart';
import 'package:flutter_ai/widgets/mark_down_text.dart';
import 'package:flutter_ai/widgets/stream_loading_indicator.dart';
import 'package:flutter_ai/widgets/vector_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late FocusScopeNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusNode = FocusScope.of(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTapSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _focusNode.unfocus();

    // Pass the current chats as history (before adding the new message)
    context.read<ChatListBloc>().add(
      ChatAdd(chat: Chat(text: text, isUser: true)),
    );

    _scrollToBottom();
  }

  void _addGeneratedChat(String text) {
    debugPrint('ADD GENERATED CHAT CALLED: $text');
    context.read<ChatListBloc>().add(ChatAdd(chat: Chat(text: text)));
  }

  void _removeLastUserMessage(String error) {
    debugPrint('REMOVE LAST USER MESSAGE CALLED');
    context.read<ChatListBloc>().add(ChatError(error));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const VectorIcon(icon: AppIcons.menu),
        ),
        title: const Text('Gyani Ai'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatListBloc, ChatListState>(
              builder: (context, state) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                    left: AppSpacing.m,
                    right: AppSpacing.m,
                    top: AppSpacing.s,
                    bottom: AppSpacing.xxxl,
                  ),
                  itemCount: state.chats.length,
                  itemBuilder: (context, index) {
                    final message = state.chats[index];
                    final isLastMessage = index == state.chats.length - 1;

                    if (message.isUser && isLastMessage) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ChatBubble(text: message.text),
                          // Stream result
                          switch (state.responseStete) {
                            // AI message — use StreamBuilder if stream is available
                            // and text is still empty (stream hasn't completed yet)
                            ResponseStreamming(:final stream) =>
                              _AiStreamingMessage(
                                stream: stream,
                                onCompleteGenerate: _addGeneratedChat,
                                onData: _scrollToBottom,
                                onError: _removeLastUserMessage,
                              ),
                            ResponseError(:final error) => ErrorChatBubble(
                              error: error,
                            ),
                            _ => const SizedBox(),
                          },
                        ],
                      );
                    }

                    // AI message with completed text
                    if (message.isUser) {
                      return ChatBubble(text: message.text);
                    }

                    return isLastMessage
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MarkDownText(text: message.text),
                              AppGaps.hM,
                              Center(
                                child: Text(
                                  'Generated by Gemini-2.5-flash model.',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          )
                        : MarkDownText(text: message.text);
                  },
                );
              },
            ),
          ),
          // Prompt Edition Panel
          SafeArea(
            top: false,
            child: PromptEditingPanel(
              controller: _controller,
              onTapSend: _onTapSend,
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorChatBubble extends StatelessWidget {
  const ErrorChatBubble({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: const BorderRadius.all(AppRadius.l),
        border: Border.all(color: colorScheme.error.withAlpha(128)),
      ),
      child: MarkDownText(text: error),
    );
  }
}

/// Displays an AI message that is currently streaming.
class _AiStreamingMessage extends StatelessWidget {
  const _AiStreamingMessage({
    required this.stream,
    required this.onCompleteGenerate,
    required this.onData,
    required this.onError,
  });

  final Stream<String>? stream;
  final void Function(String) onCompleteGenerate;
  final VoidCallback onData;
  final void Function(String) onError;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        // Update the message text as data comes in
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => onCompleteGenerate(snapshot.data!),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const StreamLoadingIndicator(key: ValueKey('loading'));
        } else if (snapshot.hasError) {
          final error = snapshot.error as AiException;
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => onError(error.message),
          );
          return ErrorChatBubble(
            key: const ValueKey('error'),
            error: error.message,
          );
        } else {
          SchedulerBinding.instance.addPostFrameCallback((_) => onData());
          return MarkDownText(
            key: const ValueKey('content'),
            text: snapshot.data!,
          );
        }
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        margin: const EdgeInsets.only(
          bottom: AppSpacing.l,
          top: AppSpacing.l,
          left: AppSpacing.xxxl,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: AppRadius.xl,
            topRight: AppRadius.xs,
            bottomLeft: AppRadius.xl,
            bottomRight: AppRadius.xl,
          ),
        ),
        child: SelectableText(text, style: theme.textTheme.bodyLarge),
      ),
    );
  }
}

class PromptEditingPanel extends StatelessWidget {
  PromptEditingPanel({
    super.key,
    required this.controller,
    required this.onTapSend,
  }) : _isEditing = ValueNotifier<bool>(false);

  final TextEditingController controller;
  final VoidCallback onTapSend;
  final ValueNotifier<bool> _isEditing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.m,
        right: AppSpacing.m,
        top: AppSpacing.s,
        bottom: AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: AppRadius.xl,
          topRight: AppRadius.xl,
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: (value) => _isEditing.value = value.isNotEmpty,
            maxLines: 5,
            minLines: 1,
            style: theme.textTheme.bodyLarge,
            decoration: const InputDecoration(hintText: 'Ask me anything'),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const VectorIcon(icon: AppIcons.cross),
              ),
              AppGaps.wS,
              IconButton(
                onPressed: () {},
                icon: const VectorIcon(icon: AppIcons.tune),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const VectorIcon(icon: AppIcons.mic),
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(48),
                  side: BorderSide(
                    width: 1,
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
              AppGaps.wS,
              ValueListenableBuilder(
                valueListenable: _isEditing,
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: value
                        ? IconButton(
                            key: const ValueKey('send'),
                            onPressed: onTapSend,
                            icon: const VectorIcon(icon: AppIcons.send),
                            style: IconButton.styleFrom(
                              fixedSize: const Size.square(48),
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                            ),
                          )
                        : IconButton(
                            key: const ValueKey('aiEdit'),
                            onPressed: () {},
                            icon: const VectorIcon(icon: AppIcons.aiEdit),
                            style: IconButton.styleFrom(
                              fixedSize: const Size.square(48),
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
