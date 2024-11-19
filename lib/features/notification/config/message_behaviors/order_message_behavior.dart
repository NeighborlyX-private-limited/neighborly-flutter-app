import 'dart:convert';
import '../message_behavior.dart';

class OrderMessageBehavior implements MessageBehavior {
  @override
  String get key => 'order';

  @override
  Future<void> handle(Map<String, dynamic> data) async {
    print('...OrderMessageBehavior and handle start with:$data');
    print('...OrderMessageBehavior and handle jsonEncode:${jsonEncode(data)}');
    print('...OrderMessageBehavior and handle type_os:${data['type_os']}');
    print('...OrderMessageBehavior and handle runtimeType:${data.runtimeType}');

    if (data.toString() != '{}') {
      if (data['type_os'] == 'OrderEstimate') {
        // Modular.get<SharedNavigator>().updateEstimatesOnHome();
      }

      if (data['type_os'] != 'OrderEstimate') {
        // final order = OrderRequestModel.fromJson(data);
        // Modular.get<SharedNavigator>().openOrderRequestModal(order);
      }
    } else {
      // Modular.get<SharedNavigator>().updateEstimatesOnHome();
    }
  }
}
