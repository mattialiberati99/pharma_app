import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/pages/cart/check.dart';
import 'package:pharma_app/src/providers/settings_provider.dart';
import 'package:pharma_app/src/providers/user_provider.dart';

import '../../main.dart';
import '../models/address.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/extra.dart';

import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/shop.dart';
import '../repository/cart_repository.dart';
import '../repository/order_repository.dart' as orderRepo;
import 'acquistiRecenti_provider.dart';

final cartProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});

class CartProvider with ChangeNotifier {
  List<Cart> carts = [];
  Address? deliveryAddress;
  CreditCard? paymentMethod;
  Coupon? coupon;
  bool loading = false;
  AcquistiRecentiProvider? acquistiRecenti;

  CartProvider() {
    Future.delayed(Duration.zero, () async {
      carts = await getCart();
      notifyListeners();
    });
  }

  double get total {
    double total = 0.00;
    carts.forEach((cart) {
      total += cart.getFarmacoPrice() * cart.quantity!;
    });
    // prendo solo le prime due cifre decimali
    double formattedTotal = double.parse(total.toStringAsFixed(2));
    return formattedTotal;
  }
/* 
  double get veroTotale {
    return total;
    //return double.parse((sconto - total).toStringAsFixed(2));
    //return double.parse((total + veroSconto).toStringAsFixed(2));
  } */

  int get count {
    int counter = 0;
    for (var cart in carts) {
      counter += cart.quantity!;
    }
    return counter;
  }

  double get veroSconto {
    return double.parse(
        ((total - sconto) != total ? (total - sconto) : 0).toStringAsFixed(2));
  }

  double get sconto {
    //if(discount.discountableType)
    double sconto = 0;
    carts.forEach((cart) {
      sconto += cart.getFarmacoDiscountPrice() * cart.quantity!;
    });
    double formattedSconto = double.parse(sconto.toStringAsFixed(2));
    return formattedSconto;
  }

  double get delivery_fee {
    double deliv_fee = 0;
    List<String> already_added_id = [];
    carts.forEach((cart) {
      if (!already_added_id.contains(cart.product!.restaurant!.id!)) {
        already_added_id.add(cart.product!.restaurant!.id!);
        deliv_fee += cart.product!.restaurant!.deliveryFee ?? 0;
      }
    });
    double formattedDeliveryFee = double.parse(deliv_fee.toStringAsFixed(2));
    return formattedDeliveryFee;
  }

  add(Farmaco food, int quantity, List<Extra> extras) {
    int? index = cartContainsProduct(food, extras);
    if (index != null) {
      carts[index].quantity = carts[index].quantity! + quantity;
      updateCart(carts[index]);
    } else {
      carts.add(new Cart()
        ..product = food
        ..quantity = quantity
        ..extras = extras);
      addCart(carts.last, false);
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

  Future<List<Order>?> addOrderPayPal() async {
    logger.info("adding order");
    Map<String, List<FarmacoOrder>> cartSplitPerShop = {};
    List<Order> orders = [];
    for (Cart cart in carts) {
      try {
        if (cartSplitPerShop[cart.product!.restaurant!.id!] != null) {
          print("added");
          cartSplitPerShop[cart.product!.restaurant!.id!]!
              .add(cart.foodOrder());
        } else {
          print("created");
          cartSplitPerShop[cart.product!.restaurant!.id!] = [cart.foodOrder()];
        }
      } catch (e) {
        print(e);
        print("Error Created");
        cartSplitPerShop[cart.product!.restaurant!.id!] = [cart.foodOrder()];
      }
    }

    try {
      for (MapEntry entry in cartSplitPerShop.entries) {
        Order order = Order();
        order.foodOrders = entry.value;
        order.consegna = DateTime.now().add(Duration(
            days: entry.value.first.product!.restaurant!.giorni_consegna!));
        order.importo = total.toStringAsFixed(2);
        OrderStatus orderStatus = OrderStatus();
        orderStatus.id = OrderStatus.received;
        order.orderStatus = orderStatus;
        order.deliveryAddress = deliveryAddress;
        order.sconto = (-veroSconto);
        order.discountCode = coupon?.code ?? '';

        print("Fin qui tutto ok");
        Order? newOrder = await orderRepo.addOrder(order, 'PayPal');

        if (newOrder != null) {
          coupon = null;
          paymentMethod = null;
          loading = false;
          notifyListeners();
          orders.insert(0, newOrder);
          
          notifyListeners();
        } else {
          loading = false;
          notifyListeners();
        }
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      return null;
    }
    return orders;
  }

  Future<List<Order>?> addOrderContanti() async {
    logger.info("adding order");
    Map<String, List<FarmacoOrder>> cartSplitPerShop = {};
    List<Order> orders = [];
    for (Cart cart in carts) {
      try {
        if (cartSplitPerShop[cart.product!.restaurant!.id!] != null) {
          print("added");
          cartSplitPerShop[cart.product!.restaurant!.id!]!
              .add(cart.foodOrder());
        } else {
          print("created");
          cartSplitPerShop[cart.product!.restaurant!.id!] = [cart.foodOrder()];
        }
      } catch (e) {
        print(e);
        print("Error Created");
        cartSplitPerShop[cart.product!.restaurant!.id!] = [cart.foodOrder()];
      }
    }

    try {
      for (MapEntry entry in cartSplitPerShop.entries) {
        Order order = Order();
        order.foodOrders = entry.value;
        order.consegna = DateTime.now().add(Duration(
            days: entry.value.first.product!.restaurant!.giorni_consegna!));
        order.importo = total.toStringAsFixed(2);
        OrderStatus orderStatus = OrderStatus();
        orderStatus.id = OrderStatus.received;
        order.orderStatus = orderStatus;
        order.deliveryAddress = deliveryAddress;
        order.sconto = (-veroSconto);
        order.discountCode = coupon?.code ?? '';

        print("Fin qui tutto ok");
        Order? newOrder = await orderRepo.addOrder(order, 'Contanti');

        if (newOrder != null) {
          coupon = null;
          paymentMethod = null;
          loading = false;
          notifyListeners();
          orders.insert(0, newOrder);
          notifyListeners();
        } else {
          loading = false;
          notifyListeners();
        }
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      return null;
    }
    return orders;
  }

  Future<List<Order>?> addOrder() async {
    print("adding order");
    Map<String, List<FarmacoOrder>> cartSplitPerShop = {};
    List<Order> orders = [];

    for (Cart cart in carts) {
      try {
        if (cartSplitPerShop[cart.product!.restaurant!.id!] != null) {
          print("added");
          cartSplitPerShop[cart.product!.restaurant!.id!]!
              .add(cart.foodOrder());
        } else {
          print("created");
          cartSplitPerShop[cart.product!.restaurant!.id!] = [cart.foodOrder()];
        }
      } catch (e) {
        print(e);
        print("Error Created");
        cartSplitPerShop[cart.product!.restaurant!.id!] = [cart.foodOrder()];
      }
    }
    //Creiamo multipli ordini per i vari negozi coinvolti
    try {
      for (MapEntry entry in cartSplitPerShop.entries) {
        Order order = Order();
        order.foodOrders = entry.value;
        order.consegna = DateTime.now().add(Duration(
            days: entry.value.first.product!.restaurant!.giorni_consegna!));
        order.importo = total.toStringAsFixed(2);
        OrderStatus orderStatus = OrderStatus();
        orderStatus.id = OrderStatus.received;
        order.orderStatus = orderStatus;
        order.deliveryAddress = deliveryAddress;
        order.sconto = (-veroSconto);
        order.discountCode = coupon?.code ?? '';

        logger.info("Fin qui tutto ok");

        logger.log(order.deliveryAddress!.toMap());
        try {
          Stripe.Stripe.publishableKey = setting.value.stripeKey!;
          order.card = paymentMethod!;
          await Stripe.Stripe.instance.dangerouslyUpdateCardDetails(
              Stripe.CardDetails(
                  number: paymentMethod!.number,
                  expirationMonth:
                      int.parse(paymentMethod!.expiration!.split('/')[0]),
                  expirationYear: int.parse(
                    paymentMethod!.expiration!.split('/')[1],
                  ),
                  cvc: paymentMethod!.cvc));

          final billingDetails = Stripe.BillingDetails(
            email: currentUser.value.email,
            name: currentUser.value.name,
          ); // mocked data for tests

          final stripePaymentMethod =
              await Stripe.Stripe.instance.createPaymentMethod(
                  params: Stripe.PaymentMethodParams.card(
            paymentMethodData: Stripe.PaymentMethodData(
              billingDetails: billingDetails,
            ),
          ));

          Map intentRequest = await orderRepo.getPaymentIntent(order);

          Stripe.Stripe.merchantIdentifier = intentRequest['connected_id'];
          Stripe.PaymentIntent paymentIntentResult =
              await Stripe.Stripe.instance.confirmPayment(
            paymentIntentClientSecret: intentRequest['payment_intent'],
            data: Stripe.PaymentMethodParams.card(
              paymentMethodData: Stripe.PaymentMethodData(
                billingDetails: billingDetails,
              ),
            ),
          );

          if (paymentIntentResult.nextAction != null) {
            paymentIntentResult = await Stripe.Stripe.instance
                .handleNextAction(paymentIntentResult.clientSecret);
          }

          if (paymentIntentResult.status ==
              Stripe.PaymentIntentsStatus.RequiresCapture) {
            Order? newOrder = await orderRepo.addOrder(
                order, paymentIntentResult: paymentIntentResult, 'credit_card');

            if (newOrder != null) {
              coupon = null;
              paymentMethod = null;
              loading = false;
              notifyListeners();
              orders.insert(0, newOrder);
              notifyListeners();
            } else {
              loading = false;
              notifyListeners();
            }
          } else {
            print("no status");

            loading = false;
            notifyListeners();
          }
        } on Stripe.StripeConfigException catch (stripeError) {
          print(stripeError.message);
          loading = false;
          notifyListeners();
        } catch (e, stack) {
          print("--------------------");
          print(e.toString());
          print(stack);

          loading = false;
          notifyListeners();
        }
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      return null;
    }
    return orders;
  }

  Future<List<Order>?> proceedOrder(BuildContext context, String method) async {
    loading = true;
    notifyListeners();

    List<Order>? orders = [];
    try {
      if (method == 'Carta') {
        orders = await addOrder();
      } else if (method == 'Contanti') {
        orders = await addOrderContanti();
      } else if (method == 'PayPal') {
        orders = await addOrderPayPal();
      }

      if (orders != null && orders.isNotEmpty) {
        coupon = null;
        paymentMethod = paymentMethod;
        loading = false;
        notifyListeners();
        return orders;
      } else {
        print('empty orders');
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
