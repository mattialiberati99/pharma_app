import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/components/primary_circular_button.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/payment_methods/widget/horizontal_card_list.dart';

import '../../components/custom_app_bar.dart';
import '../../models/credit_card.dart';
import '../../providers/cart_provider.dart';
import '../../providers/credit_cards_provider.dart';
import '../../repository/paymentCards_repository.dart';

// create a steteProvider hold a int value
final paymentMethodProvider = StateProvider((ref) => 0);

class PaymentMethods extends ConsumerStatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends ConsumerState<PaymentMethods> {
  late int _selectedMethod;
  CreditCard? _selectedCard;

  @override
  void initState() {
    _selectedMethod = ref.read(paymentMethodProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    //create a column with 3 radio buttons for credit card, paypal and cash
    return Scaffold(
      appBar: CustomAppBar(title: "Metodo di pagamento"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.mqw * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Text("Tipi di pagamento",
                  style: context.textTheme.bodyText2?.copyWith(fontSize: 20)),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.mastercard,
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(context.loc.visa_card)),
                Radio(
                  value: 0,
                  groupValue: _selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value as int;
                      ref.read(paymentMethodProvider.notifier).state =
                          _selectedMethod;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  AppAssets.paypal,
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(context.loc.paypal)),
                Radio(
                  value: 1,
                  groupValue: _selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value as int;
                      ref.read(paymentMethodProvider.notifier).state =
                          _selectedMethod;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.cash,
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(context.loc.cash_on_delivery)),
                Radio(
                  value: 2,
                  groupValue: _selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value as int;
                      ref.read(paymentMethodProvider.notifier).state =
                          _selectedMethod;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
            Visibility(
              visible: _selectedMethod == 0,
              child: Row(
                children: [
                  PrimaryCircularButton(
                      size: 48,
                      onPressed: () => Navigator.of(context)
                          .pushNamed('GestisciCarte')
                          .then((v) => setState(() {}))),
                  SizedBox(
                    width: context.mqw * 0.7,
                    height: 140,
                    child: HorizontalCardList(
                      cards: cards,
                      //selected: _selectedCard,
                      onTap: (cardIndex) {
                        _selectedCard = cards[cardIndex];
                        print('CARTA SELEZIONATA: ${_selectedCard?.number}');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // <-- CARDS LIST
            PrimaryNoSizedButton(
                hMargin: 32,
                label: "IMPOSTA",
                height: 55,
                onPressed: () => {
                      if (_selectedMethod == 0 && _selectedCard != null)
                        {
                          cartProv.paymentMethod = _selectedCard,
                          cartProv.notifyListeners(),
                          ref.refresh(creditCardsProvider.future),
                          Navigator.of(context).pop(),
                        }
                      else if (_selectedMethod != 0 && _selectedCard == null)
                        {
                          Navigator.of(context).pop(),
                        }
                      else if (_selectedMethod == 0 && _selectedCard == null)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Seleziona una carta di credito'))),
                        },
                    }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
