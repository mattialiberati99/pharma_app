import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/models/farmaco.dart';

import '../models/address.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/extra.dart';

import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../repository/cart_repository.dart';
import '../repository/order_repository.dart' as orderRepo;

final cartProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});

class CartProvider with ChangeNotifier {
  List<Cart> carts = [];
  Address? deliveryAddress;
  CreditCard? paymentMethod;
  Coupon? coupon;
  bool loading = false;

  CartProvider() {
    Future.delayed(Duration.zero, () async {
      carts = await getCart();
      notifyListeners();
    });
  }

  double get total {
    double total = 0;
    carts.forEach((cart) {
      total += cart.getFarmacoPrice() * cart.quantity!;
    });
    return total;
  }

  int get count {
    int counter = 0;
    for (var cart in carts) {
      counter += cart.quantity!;
    }
    return counter;
  }

  double get sconto {
    //if(discount.discountableType)
    return 0;
  }

  double get delivery_fee {
    double deliv_fee = 0;
    List<String> already_added_id = [];
    carts.forEach((cart) {
      if (!already_added_id.contains(cart.product!.farmacia!.id!)) {
        already_added_id.add(cart.product!.farmacia!.id!);
        deliv_fee += cart.product!.farmacia!.deliveryFee ?? 0;
      }
    });
    return deliv_fee;
  }

  add(Farmaco product, int quantity, List<Extra> extras) async {
    int? index = cartContainsProduct(product, extras);
    if (index != null) {
      carts[index].quantity = carts[index].quantity! + quantity;
      await updateCart(carts[index]);
    } else {
      Cart tempCart = Cart()
        ..product = product
        ..quantity = quantity
        ..extras = extras;
      //if not null
      Cart? cart = await addCart(tempCart, false);
      if (cart != null) {
        print(cart.product?.name);
        carts.add(cart);
      }
    }
    notifyListeners();
  }

  decrease(Farmaco product, List<Extra>? extras) {
    int? index = cartContainsProduct(product, extras);
    print(index);
    if (index != null) {
      carts[index].quantity = carts[index].quantity! - 1;
      if (carts[index].quantity == 0) {
        removeCart(carts[index]);
        carts.removeAt(index); //causa errore
      }
      updateCart(carts[index]);
    }
    notifyListeners();
  }

  remove(Farmaco product, List<Extra>? extras) {
    print(product.name);
    int? index = cartContainsProduct(product, extras);
    print(index);
    if (index != null) {
      removeCart(carts[index]);
      carts.removeAt(index);
    }
    notifyListeners();
  }

  int? cartContainsProduct(Farmaco product, List<Extra>? extras) {
    int? contains;
    for (int i = 0; i < carts.length; i++) {
      if (carts[i].product == product &&
          carts[i].extras?.length == extras?.length) {
        if (extras != null && extras.isNotEmpty) {
          print("here");
          bool match = true;
          for (Extra extra in carts[i].extras!) {
            print("CartExtra - ${extra.id}");
            extras.forEach((element) {
              print(element.id);
            });
            if (!extras.contains(extra)) {
              print("notCont");
              match = false;
              break;
            }
          }
          if (match) {
            contains = i;
          }
        } else {
          contains = i;
          break;
        }
      } else {
        print(carts[i].extras?.length);
        print(extras?.length);
        print(carts[i].product!.id);
        print(product.id);
      }
    }
    return contains;
  }

  clear() {
    for (Cart delCart in carts) {
      removeCart(delCart);
    }
    carts.clear();
    notifyListeners();
  }

  Future<List<Order>?> addOrder() async {
    print("adding order");
    Map<String, List<FarmacoOrder>> cartSplitPerShop = {};
    List<Order> orders = [];
    for (Cart cart in carts) {
      try {
        if (cartSplitPerShop[cart.product!.farmacia!.id!] != null) {
          print("added");
          cartSplitPerShop[cart.product!.farmacia!.id!]!.add(cart.foodOrder());
        } else {
          print("created");
          cartSplitPerShop[cart.product!.farmacia!.id!] = [cart.foodOrder()];
        }
      } catch (e) {
        print(e);
        print("Error Created");
        cartSplitPerShop[cart.product!.farmacia!.id!] = [cart.foodOrder()];
      }
      print("looop");
    }
    print(cartSplitPerShop.length);
    //Creiamo multipli ordini per i vari negozi coinvolti
    try {
      for (MapEntry entry in cartSplitPerShop.entries) {
        Order _order = new Order();
        _order.foodOrders = entry.value;
        //_order.tax = checkout!.cart!.taxAmount;
        _order.deliveryFee = delivery_fee;
        //_order.note = checkout.note;
        _order.consegna = DateTime.now().add(Duration(
            days: entry.value.first.food!.restaurant!.giorni_consegna!));
        //_order.importo = checkout.importo;
        OrderStatus _orderStatus = new OrderStatus();
        _orderStatus.id = OrderStatus.received;
        _order.orderStatus = _orderStatus;
        _order.deliveryAddress = deliveryAddress;
        _order.sconto = sconto;
        _order.discountCode = coupon?.code ?? '';

        print("Fin qui tutto ok");
        Order? order = await orderRepo.addOrder(_order, card: paymentMethod);
        if (order != null) {
          orders.insert(0, order);
          notifyListeners();
        } else {
          _order.foodOrders.forEach((element) {
            carts.add(Cart()
              ..product = element.food
              ..extras = element.extras
              ..quantity = element.quantity);
          });
        }
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      return orders;
    }
    return orders;
  }

  Future<List<Order>?> proceedOrder(BuildContext context) async {
    loading = true;
    notifyListeners();
    List<Order>? orders = [];
    try {
      orders = await addOrder();

      if (orders != null && orders.isNotEmpty) {
        coupon = null;
        paymentMethod = null;
        loading = false;
        notifyListeners();
        return orders;
      } else {
        print("empty orders");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Errore nel pagamento, riprova"),
        ));
        loading = false;
        notifyListeners();
      }
    } catch (e, s) {
      print(e);
      print(s);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Errore nel pagamento, riprova"),
      ));
      loading = false;
      notifyListeners();
    }
    return orders;
  }

//   Future<String> requestPaymentIntent() async {
//     Order _order = new Order();
//     _order.foodOrders = [];
//     _order.deliveryFee = delivery_fee;
//     _order.sconto = sconto;
//     carts.forEach((_cart) {
//       FarmacoOrder _productOrder = FarmacoOrder();
//       _productOrder.quantity = _cart.quantity;
//       _productOrder.price = _cart.product!.price;
//       _productOrder.food = _cart.product;
//       _productOrder.extras = _cart.extras!;
//       _order.foodOrders.add(_productOrder);
//     });
//     return orderRepo.getPaymentIntent(_order);
//   }
// }
}
