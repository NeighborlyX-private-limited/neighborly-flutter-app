import '../message_behavior.dart';

class OrderMessageBehavior implements MessageBehavior {
  @override
  String get key => 'order';

  @override
  Future<void> handle(Map<String, dynamic> data) async {
    if (data.toString() != '{}') {
      if (data['type_os'] == 'OrderEstimate') {}

      if (data['type_os'] != 'OrderEstimate') {}
    } else {}
  }
}
