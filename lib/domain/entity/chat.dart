class Chat {
  String text;
  final bool isUser;
  Stream<String>? stream;

  Chat.user(this.text) : isUser = true, stream = null;

  Chat.ai({required this.stream}) : isUser = false, text = '';

  void setText(String text) {
    this.text = text;
    stream = null;
  }
}
