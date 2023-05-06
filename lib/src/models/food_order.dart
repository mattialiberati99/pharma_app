import '../helpers/custom_trace.dart';
import '../models/extra.dart';
import 'farmaco.dart';

class FarmacoOrder {
  String? id;
  double? price;
  int? quantity;
  List<Extra> extras = [];
  Farmaco? food;
  DateTime? dateTime;

  FarmacoOrder();

  FarmacoOrder.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'] : 0.0;
      food = jsonMap['food'] != null
          ? Farmaco.fromJSON(jsonMap['food'])
          : Farmaco.fromJSON({});
      dateTime = DateTime.parse(jsonMap['updated_at']);
      extras = jsonMap['extras'] != null
          ? List.from(jsonMap['extras'])
              .map((element) => Extra.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      id = '';
      price = 0.0;
      quantity = 0;
      food = Farmaco.fromJSON({});
      dateTime = DateTime(0);
      extras = [];
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;
    map["food_id"] = food!.id;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
