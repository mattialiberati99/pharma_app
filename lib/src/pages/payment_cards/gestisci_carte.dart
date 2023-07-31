import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';

import '../../../generated/l10n.dart';
import '../../components/custom_app_bar.dart';
import '../../helpers/app_config.dart';
import '../../helpers/helper.dart';
import '../../models/credit_card.dart';
import '../../models/payment_method.dart';
import '../../providers/cart_provider.dart';
import '../../repository/paymentCards_repository.dart';
import 'widgets/EditCreditCardWidget.dart';
import 'widgets/GestisciCarteWidget.dart';

class CarteWidget extends ConsumerStatefulWidget {
  //final OrderType type;
  const CarteWidget({Key? key}) : super(key: key);

  @override
  _CarteWidgetState createState() => _CarteWidgetState();
}

class _CarteWidgetState extends ConsumerState<CarteWidget> {
  bool _loaded = false;
  CreditCard? selected;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  _loadCards() async {
    _loaded = await getUserCreditCards();
    final defaultC = cards.where((element) => element.defaultCard);
    if (defaultC.isNotEmpty) selected = defaultC.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Column(
        children: [
          Positioned(
            top: App(context).appHeight(20),
            bottom: 0,
            left: 0,
            right: 0,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: App(context).appHeight(80),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text("Metodo di pagamento",
                            style: ExtraTextStyles.normalBlackBold),
                      ),
                      Expanded(
                        child: _loaded
                            ? GestisciCarteWidget(
                                cards: cards,
                                selected: selected,
                                onTap: (cardIndex) {
                                  //if (widget.type == OrderType.shop) {
                                  selected = cards[cardIndex];
                                  final cartProv = ref.watch(cartProvider);
                                  final orderProv = ref.watch(ordersProvider);
                                  cartProv.paymentMethod = cards[cardIndex];
                                  Navigator.of(context).pop();
                                  Helper.nextOrderPage(
                                      context, cartProv, orderProv);
                                  //}  else if (widget.type ==
                                  //     OrderType.booking) {
                                  //   selected = cards[cardIndex];
                                  //   final prenotazioneCartProv = ref
                                  //       .watch(prenotazioneCartProvider);
                                  //   prenotazioneCartProv.paymentMethod =
                                  //       cards[cardIndex];
                                  //   Navigator.of(context).pop();
                                  //   Helper.nextBookingPage(
                                  //       context, prenotazioneCartProv);
                                  // }
                                },
                              )
                            : EditCreditCard(
                                onChanged: (card) async {
                                  if (card != null) {
                                    if (card.id == null) {
                                      await addCreditCard(card);
                                    } else {
                                      await updateCreditCard(card);
                                    }
                                  }
                                  setState(() => _loaded = true);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )),
    );
  }
}
