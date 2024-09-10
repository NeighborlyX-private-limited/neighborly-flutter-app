import 'dart:convert';

import '../message_behavior.dart';

class OrderMessageBehavior implements MessageBehavior {
  @override
  String get key => 'order';

  @override
  Future<void> handle(Map<String, dynamic> data) async {
    print(' xxx OrderMessageBehavior=' + data.toString());
    print(' xxx OrderMessageBehavior=' + jsonEncode(data).toString());
    print(' xxx OrderMessageBehavior type_os=${data['type_os']}');
    print(
        ' xxx OrderMessageBehavior runtimeType=' + data.runtimeType.toString());

    if (data.toString() != '{}') {
      if (data['type_os'] == 'OrderEstimate') {
        // Modular.get<SharedNavigator>().updateEstimatesOnHome();
      }
      ;

      if (data['type_os'] != 'OrderEstimate') {
        // final order = OrderRequestModel.fromJson(data);
        // Modular.get<SharedNavigator>().openOrderRequestModal(order);
      }
    } else {
      // Modular.get<SharedNavigator>().updateEstimatesOnHome();
    }
  }
}
