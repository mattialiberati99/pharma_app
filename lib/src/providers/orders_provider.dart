import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../repository/order_repository.dart' as orderRepo;

final ordersProvider = ChangeNotifierProvider<OrdersProvider>((ref) {
  return OrdersProvider();
});

class OrdersProvider with ChangeNotifier {
  List<Order> orders = [];
  int totalCount = 0;
  OrdersProvider() {
    Future.delayed(Duration.zero, () async {
      orders = await orderRepo.getOrders();
      totalCount = await orderRepo.getOrdersCount();
      notifyListeners();
    });
  }

  get ordersInCorso => orders.where(
      (element) => element.orderStatus!.id! < OrderStatus.delivered);

  get ordersCompletati => orders.where((element) =>
      element.orderStatus!.id! >= OrderStatus.delivered);

  order(id) => orders.firstWhereOrNull((element) => element.id == id);

  Future<void> reloadOrders() async{
    orders = await orderRepo.getOrders();
    totalCount = await orderRepo.getOrdersCount();
    notifyListeners();
    return;
  }

  void add(Order newOrder) {
    orders.add(newOrder);
    notifyListeners();
  }
}

/// stateProvider to hold a notes added from cart page
final noteOrderProvider = StateProvider.autoDispose((ref) => '');
