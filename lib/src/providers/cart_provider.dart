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
    double sconto = 0;
    carts.forEach((cart) {
      sconto += cart.getFarmacoDiscountPrice() * cart.quantity!;
    });
    return sconto;
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

  Future<List<Order>?> addPrenotazione(Shop farmacia) async {
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
    try {
      for (MapEntry entry in cartSplitPerShop.entries) {
        Order order = Order();
        Payment payment = Payment('Carta');
        order.foodOrders = entry.value;
        //_order.tax = checkout!.cart!.taxAmount;
        //order.note = checkout.note;
        //order.oraRitiro
        logger.info(int.parse(farmacia.id!));
        order.farmaciaId = int.tryParse(farmacia.id!);
        order.consegna = DateTime.now();
        order.payment = payment;
        //order.payment!.method = 'Carta';
        logger.info(order.payment!.method.toString());
        //_order.importo = checkout.importo;
        OrderStatus orderStatus = OrderStatus();
        orderStatus.id = OrderStatus.received;
        order.orderStatus = orderStatus;
        order.active = false;
        order.deliveryAddress = deliveryAddress;
        order.sconto = sconto;
        order.discountCode = coupon?.code ?? '';
        try {
          Order? newOrder = await orderRepo.addOrder(order);
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
        Order _order = Order();
        _order.foodOrders = entry.value;
        //_order.tax = checkout!.cart!.taxAmount;
        //_order.note = checkout.note;
        _order.farmaciaId = int.tryParse(entry.value.first.food!.farmacia!.id);
        _order.consegna = DateTime.now().add(
            Duration(days: entry.value.first.food!.farmacia!.giorni_consegna!));
        _order.importo = total.toStringAsFixed(2);
        OrderStatus _orderStatus = OrderStatus();
        _orderStatus.id = OrderStatus.received;
        _order.orderStatus = _orderStatus;
        _order.deliveryAddress = deliveryAddress;
        _order.sconto = sconto;
        _order.discountCode = coupon?.code ?? '';

        print("Fin qui tutto ok");
        try {
          Stripe.Stripe.publishableKey = setting.value.stripeKey!;
          _order.card = paymentMethod!;
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

          Map intentRequest = await orderRepo.getPaymentIntent(_order);

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
            Order? newOrder = await orderRepo.addOrder(_order,
                paymentIntentResult: paymentIntentResult);

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
        acquistiRecenti?.saveListaAcquistiRecenti(orders); // Acquisti Recenti
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
