import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/food_order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../repository/user_repository.dart';
import 'credit_card.dart';

class Order {
  String? id;
  List<FarmacoOrder> foodOrders = [];
  OrderStatus? orderStatus;
  double? deliveryFee;
  bool? active;
  DateTime? dateTime;
  Payment? payment;
  Address? deliveryAddress;
  String? note;
  String? importo;
  double? sconto;
  DateTime? consegna;
  DateTime? oraRitiro;
  String? discountCode;
  CreditCard? card;
  int? restaurantId;
  User? user;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      active = jsonMap['active'] ?? false;
      orderStatus = jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : OrderStatus.fromJSON({});
      //dateTime = DateTime.parse(jsonMap['updated_at']);
      deliveryAddress = jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : Address.fromJSON({});
      payment = jsonMap['payment'] != null
          ? Payment.fromJSON(jsonMap['payment'])
          : Payment.fromJSON({});
      foodOrders = jsonMap['food_orders'] != null
          ? List.from(jsonMap['food_orders'])
              .map((element) => FarmacoOrder.fromJSON(element))
              .toList()
          : [];
      print(foodOrders);
      try {
        note = jsonMap['note'];
      } catch (e) {
        note = "";
      }

      try {
        importo = jsonMap['importo'];
      } catch (e) {
        importo = "";
      }
      sconto = jsonMap['sconto'] != null ? jsonMap['sconto'].toDouble() : 0.0;
      consegna = DateTime.tryParse(jsonMap['delivery_time'] ?? "");
      oraRitiro = DateTime.tryParse(jsonMap['ora_ritiro'] ?? "");
      restaurantId = int.tryParse(jsonMap['restaurant_id'] ?? '0');
      print('restaurantId: $restaurantId');
    } catch (e, stack) {
      print(e);
      print(stack);
      id = '';
      deliveryFee = 0.0;
      active = false;
      orderStatus = OrderStatus.fromJSON({});
      dateTime = DateTime(0);
      payment = Payment.fromJSON({});
      deliveryAddress = Address.fromJSON({});
      sconto = 0.0;
      foodOrders = [];
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = currentUser.value.id;
    map["order_status_id"] = orderStatus?.id;
    map["delivery_fee"] = deliveryFee;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment?.toMap();
    if (!deliveryAddress!.isUnknown()) {
      map["delivery_address_id"] = deliveryAddress?.id;
    }
    map['delivery_time'] = consegna.toString();
    map["importo"] = importo;
    map["note"] = note;
    map["sconto"] = 0.0;
    map["coupon"] = discountCode;
    map["restaurant_id"] = foodOrders[0].product!.restaurant!.id;
    return map;
  }

  String toPaypalMap() {
    String params = "";
    params += "user_id=${user?.id}";
    params += "&order_status_id=${orderStatus?.id}";
    params += "&delivery_fee=$deliveryFee";
    /*  if (!deliveryAddress!.isUnknown()) {
      params += "&delivery_address_id= ${deliveryAddress?.id}";
    } */
    params += "&importo=$importo";
    params += "&orario=$oraRitiro";
    params += "&note=$note";
    params += "&sconto=$sconto";
    return params;
  }

  Map cancelMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["active"] = false;
    map["order_status_id"] = OrderStatus.annullato;
    return map;
  }

  bool canCancelOrder() {
    return this.active == true &&
        this.orderStatus!.id ==
            OrderStatus.preparing; // 1 for order received status
  }

  Map stripeMap() {
    var map = new Map<String, dynamic>();
    map["delivery_fee"] = deliveryFee;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["sconto"] = sconto;
    return map;
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var foodOrder in foodOrders) {
      total += foodOrder.quantity! * foodOrder.price!;
    }
    return total;
  }
}
