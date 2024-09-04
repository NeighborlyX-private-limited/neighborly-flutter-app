abstract class MessageBehavior {
  final String key;

  MessageBehavior(this.key);

  void handle(Map<String, dynamic> data);
}
