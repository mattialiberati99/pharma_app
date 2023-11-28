// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'package:pharma_app/src/providers/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';

final paypalProvider = ChangeNotifierProvider<PayPalProvider>((ref) {
  final cartProv = ref.watch(cartProvider);
  return PayPalProvider(cartProv);
});

class PayPalProvider with ChangeNotifier {
  late WebViewController webView;
  Order order = Order();
  String url = "";
  double progress = 0;

  PayPalProvider(CartProvider cartProv) {
    Future.delayed(Duration.zero, () async {
      order.foodOrders = <FarmacoOrder>[];
      // fixare data consegna
      order.consegna = DateTime.now();
      order.importo = cartProv.total.toStringAsFixed(2);
      order.user = currentUser.value;
      order.note = '';
      order.restaurantId =
          int.tryParse(cartProv.carts.first.product!.restaurant!.id!);
      OrderStatus _orderStatus = OrderStatus();
      _orderStatus.id = OrderStatus.received;
      order.orderStatus = _orderStatus;
      order.deliveryAddress = cartProv.deliveryAddress;
      order.sconto = cartProv.sconto;
      notifyListeners();
    });
  }
}
