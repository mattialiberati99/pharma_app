import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/pages/payment_cards/widgets/EditCreditCardWidget.dart';
import 'package:pharma_app/src/pages/payment_cards/widgets/GestisciCarteWidget.dart';

import '../../../models/credit_card.dart';
import '../../../providers/cart_provider.dart';
import '../../../repository/paymentCards_repository.dart';

class CarteWidget extends ConsumerStatefulWidget {
  final bool isOrder;
  const CarteWidget({Key? key, this.isOrder = false}) : super(key: key);

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    return Scaffold(
      body: Container(
        child: _loaded
            ? GestisciCarteWidget(
                cards: cards,
                selected: selected,
                onTap: (cardIndex) {
                  if (widget.isOrder) {
                    selected = cards[cardIndex];
                    cartProv.paymentMethod = cards[cardIndex];
                    Navigator.of(context).pop();
                  }
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
    );
  }
}
