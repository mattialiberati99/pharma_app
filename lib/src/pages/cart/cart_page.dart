import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/components/custom_check_box.dart';
import 'package:pharma_app/src/dialogs/AggiungiNota.dart';
import 'package:pharma_app/src/dialogs/order_success_dialog.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/cart/check.dart';
import 'package:pharma_app/src/pages/cart/widget/cart_item_tile.dart';
import 'package:pharma_app/src/pages/cart/widget/empty_cart_widget.dart';
import 'package:pharma_app/src/pages/cart/widget/footer_cart.dart';
import 'package:pharma_app/src/pages/login/widgets/CustomTextFormField.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';
import 'package:pharma_app/src/providers/user_addresses_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';
import '../../app_assets.dart';
import '../../components/bottomNavigation.dart';
import '../../helpers/app_config.dart';
import '../../models/cart.dart';
import '../../models/food_order.dart';
import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../../repository/paymentCards_repository.dart';
import '../payment_methods/payment_methods.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final pageController = PageController();
  bool isGift = false;

  double deliveryFee = 0.0;

  bool pickUp = true;
  bool delivery = false;

  // create methot to toggle pickUp and delivery
  void toggleDelivery() {
    if (pickUp) {
      setState(() {
        pickUp = false;
        delivery = true;
        deliveryFee = ref
            .watch(cartProvider)
            .carts
            .first
            .product!
            .restaurant!
            .deliveryFee!;
      });
    } else {
      setState(() {
        pickUp = true;
        delivery = false;
        deliveryFee = 0.0;
      });
    }
  }

  var prOrd = 0.0;
  var prezzoTot;
  var scontoTot;
  @override
  void initState() {
    super.initState();
    //_loadCards();
  }

  // _loadCards() async {
  //   _loaded = await getUserCreditCards();
  //   setState(() {});
  // }
  var ordine = FarmacoOrder();
  List<FarmacoOrder> prodotti = [];
  var ord = Order();
  var quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    final address = ref.watch(userDefaultCartAddressProvider) ??
        ref.watch(userDefaultAddressProvider).asData?.value;

    if (address != null) {
      cartProv.deliveryAddress = address;
    }

    final hasDelivery = (cartProv.carts.isNotEmpty)
        ? (cartProv.carts.first.product?.restaurant?.availableForDelivery)
        : false;

    final paymentMethod = ref.watch(paymentMethodProvider);
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomNavigation(sel: SelectedBottom.carrello),
          bottomSheet: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (cartProv.carts.isNotEmpty)
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(165, 50),
                        backgroundColor: AppColors.primary,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18)))),
                    child: const Text(
                      'Acquista',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Check()));
                    },
                  ),
              ],
            ),
          ),
          body: cartProv.carts.isEmpty
              ? EmptyCartWidget()
              : Container(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new),
                              onPressed: () => Navigator.of(context).pop(),
                              color: const Color(0xFF333333),
                            ),
                            const Text(
                              'Carrello',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('Cart');
                              },
                              child: const Image(
                                  image: AssetImage(
                                      'assets/immagini_pharma/Icon_shop.png')),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${cartProv.carts.length} articoli nel carrello',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(115, 9, 15, 71)),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('Search');
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Aggiungi articoli'),
                              ),
                            ]),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: context.mqh * 0.68,
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                    height: 10,
                                    thickness: 2,
                                  ),
                              itemCount: cartProv.carts.length,
                              itemBuilder: ((context, index) {
                                Cart cart = cartProv.carts.elementAt(index);
                                print(cart.toString());
                                print(cart.product.toString());
                                index == 0
                                    ? prezzoTot = cartProv
                                        .carts[index].product!.discountPrice!
                                    : prezzoTot += cartProv
                                        .carts[index].product!.discountPrice!;
                                index == 0
                                    ? scontoTot =
                                        cartProv.carts[index].product!.price!
                                    : scontoTot +=
                                        cartProv.carts[index].product!.price!;
                                prOrd = prezzoTot - scontoTot;

                                return Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: Container(
                                                color: const Color.fromARGB(
                                                    255, 242, 243, 243),
                                                child: Image(
                                                    width: 77,
                                                    height: 88,
                                                    image: NetworkImage(
                                                        //
                                                        // .product!.image!.url!),

                                                        cartProv
                                                            .carts[index]
                                                            .product!
                                                            .image!
                                                            .url!)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          cartProv.carts[index]
                                                              .product!.name
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      9,
                                                                      15,
                                                                      71),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            cartProv.remove(
                                                                cartProv
                                                                    .carts[
                                                                        index]
                                                                    .product!,
                                                                []);
                                                          },
                                                          child: const Image(
                                                              image: AssetImage(
                                                                  'assets/immagini_pharma/delOrd.png')),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${(cartProv.carts[index].product!.price! * cartProv.carts[index].quantity!).toStringAsFixed(2)}€',
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      9,
                                                                      15,
                                                                      71),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              context.mqw * 0.2,
                                                        ),
                                                        QuantitySetter(
                                                          quantity: cartProv
                                                              .carts[index]
                                                              .quantity!,
                                                          onAdd: () =>
                                                              setState(() {
                                                            cartProv.add(
                                                                cartProv
                                                                    .carts[
                                                                        index]
                                                                    .product!,
                                                                1,
                                                                cartProv
                                                                    .carts[
                                                                        index]
                                                                    .extras!);
                                                            prezzoTot += cartProv
                                                                .carts[index]
                                                                .product!
                                                                .discountPrice!;
                                                            scontoTot +=
                                                                cartProv
                                                                    .carts[
                                                                        index]
                                                                    .product!
                                                                    .price!;
                                                            quantity++;
                                                          }),
                                                          onRemove: () =>
                                                              setState(() {
                                                            if (cartProv
                                                                    .carts[
                                                                        index]
                                                                    .quantity! >
                                                                1) {
                                                              cartProv.decrease(
                                                                  cartProv
                                                                      .carts[
                                                                          index]
                                                                      .product!,
                                                                  cartProv
                                                                      .carts[
                                                                          index]
                                                                      .extras!);
                                                            } else {
                                                              cartProv.remove(
                                                                  cartProv
                                                                      .carts[
                                                                          index]
                                                                      .product!,
                                                                  cartProv
                                                                      .carts[
                                                                          index]
                                                                      .extras!);

                                                              return null;
                                                            }
                                                          }),
                                                        )
                                                      ],
                                                    ),
                                                  ]))
                                        ],
                                      ),
                                      if (index == cartProv.carts.length - 1)
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Riepilogo del pagamento',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 9, 15, 71),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Ordine Totale',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    115, 9, 15, 71),
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              '${cartProv.total.toStringAsFixed(2)}€ ',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 9, 15, 71),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Articoli scontati',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    115, 9, 15, 71),
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              '${cartProv.veroSconto}€',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 9, 15, 71),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        const Divider(
                                          thickness: 2,
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      if (index == cartProv.carts.length - 1)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Totale',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 9, 15, 71),
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              '${(cartProv.veroTotale).toStringAsFixed(2)}€',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 9, 15, 71),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                );
                              })),
                        ),
                      ],
                    ),
                  ),
                ));
    });
  }

  finalizeOrder(CartProvider cartProv, OrdersProvider orderProv,
      BuildContext context) async {
    List<Order>? orders = await cartProv.proceedOrder(context, 'carta');
    if (orders != null && orders.isNotEmpty) {
      orderProv.orders.insertAll(0, orders);
      showDialog(
          context: context,
          builder: (context) =>
              OrderSuccessDialog(currentOrder: orders.first.id ?? '#'));
    }
  }
}

class QuantitySetter extends StatefulWidget {
  final int quantity;
  final Function onAdd;
  final Function onRemove;

  const QuantitySetter({
    Key? key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<QuantitySetter> createState() => _QuantitySetterState();
}

class _QuantitySetterState extends State<QuantitySetter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 139,
      height: 38,
      decoration: ShapeDecoration(
        color: AppColors.primary.withOpacity(0.3),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size.square(35)),
              shape: MaterialStateProperty.all(const CircleBorder()),
              backgroundColor:
                  MaterialStateProperty.all(AppColors.primary.withOpacity(0.5)),
            ),
            onPressed: () => widget.onRemove(),
            child: const Icon(
              Icons.remove,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          Expanded(
            child: Container(
              width: 50,
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.quantity.toStringAsFixed(0),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          OutlinedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size.square(35)),
              shape: MaterialStateProperty.all(const CircleBorder()),
              backgroundColor: MaterialStateProperty.all(AppColors.primary),
            ),
            onPressed: () => widget.onAdd(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
