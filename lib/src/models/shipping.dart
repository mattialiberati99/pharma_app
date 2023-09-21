import 'dart:convert';

import 'package:intl/intl.dart';

import '../providers/user_provider.dart';
import 'address.dart';
import 'driver.dart';
import 'order_status.dart';
import 'payment.dart';
import 'user.dart';

class Shipping {
  String? id;
  User? user;
  Address? from;
  Address? to;
  DateTime? date;
  String? size;
  String? priority;
  OrderStatus? status;
  Driver? driver;
  double? price;
  double? value;
  Payment? payment;
  DateTime? updatedAt;
  bool active = true;
  String? note;

  Shipping();

  Shipping.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    user = jsonMap['user'] != null
        ? User.fromJSON(jsonMap['user'])
        : currentUser.value;
    from = Address.fromJSON(jsonMap['from']);
    to = Address.fromJSON(jsonMap['to']);
    date = DateTime.tryParse(jsonMap['date'].toString());
    size = jsonMap['size'];
    //priority=jsonMap['priority'];
    status = OrderStatus.fromJSON(jsonMap['order_status']);
    driver =
        jsonMap['driver'] != null ? Driver.fromJSON(jsonMap['driver']) : null;
    price = double.tryParse(jsonMap['price'].toString());
    value = double.tryParse(jsonMap['value'].toString());
    active = jsonMap['active'];
    updatedAt = DateTime.tryParse(jsonMap['updated_at'].toString());
    note = jsonMap['note'];
  }

  get canCancel =>
      active && status != null && (status?.id == OrderStatus.received);

  get driverCanCancel =>
      active && status != null && (status?.id == OrderStatus.received);

  Map<String, String?> toMap() {
    Map<String, String?> map = {};
    map['user_id'] = user?.id ?? currentUser.value.id!;
    map['from'] = jsonEncode(from!.toMap());
    map['to'] = jsonEncode(to!.toMap());
    map['date'] = DateFormat('yyyy-MM-dd').format(date!);
    map['size'] = size!;
    //map['priority']=priority;
    map['order_status_id'] = (status?.id ?? OrderStatus.received).toString();
    if (driver != null) {
      map['driver_id'] = driver!.id;
    }
    print(price);
    map['price'] = price?.toStringAsFixed(2);
    print(value);
    map['value'] = value?.toStringAsFixed(2);
    map['active'] = '1';
    return map;
  }

  Map updateMap() {
    Map<String, String?> map = {};
    map['date'] = DateFormat('yyyy-MM-dd').format(date!);
    map['order_status_id'] = status!.id!.toString();
    if (driver != null) {
      map['driver_id'] = driver!.id;
    }
    map['price'] = price?.toStringAsFixed(2);
    map['note'] = note;
    return map;
  }

  Map cancelMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id!;
    map["active"] = false;
    map["order_status_id"] = OrderStatus.annullato;
    return map;
  }

  Map stripeMap() {
    Map<String, dynamic> map = {};
    print(id);
    map['user_id'] = currentUser.value.id!;
    map['shipping_id'] = id.toString();
    map['price'] = price?.toStringAsFixed(2);
    map['value'] = value?.toStringAsFixed(2);
    return map;
  }

  Map updateDriverMap() {
    Map<String, String?> map = {};
    map['date'] = DateFormat('yyyy-MM-dd').format(date!);
    map['order_status_id'] = status!.id!.toString();
    map['note'] = note;
    map['price'] = price?.toStringAsFixed(2);
    return map;
  }

  Map cancelDriverMap() {
    Map<String, String?> map = {};
    map['driver_id'] = null;
    map['order_status_id'] = OrderStatus.received.toString();
    return map;
  }
}
