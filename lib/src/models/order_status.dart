import '../helpers/custom_trace.dart';

class OrderStatus {
  int? id;
  String? status;

  OrderStatus();

  OrderStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      status = jsonMap['status'] != null ? jsonMap['status'] : '';
    } catch (e) {
      id = 0;
      status = '';
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }
  static int received = 1;
  static int preparing = 2;
  static int in_delivery = 3;
  static int delivered = 4;
  static int annullato = 5;
  static int rimborsato = 6;
}
