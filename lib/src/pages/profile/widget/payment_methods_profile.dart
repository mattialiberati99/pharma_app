import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/credit_card.dart';
import 'package:pharma_app/src/pages/payment_cards/widgets/empty_card_widget.dart';
import 'package:pharma_app/src/providers/credit_cards_provider.dart';

import '../../../repository/paymentCards_repository.dart';
import '../../payment_cards/widgets/edit_credit_card_widget.dart';
import '../../payment_cards/widgets/manage_cards_widget.dart';

class PaymentMethodsProfile extends ConsumerStatefulWidget {
  const PaymentMethodsProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentMethodsProfile> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends ConsumerState<PaymentMethodsProfile> {
  late bool _loaded;

  @override
  void initState() {
    _loadCards();
    //ref.refresh(creditCardsProvider.future);
    super.initState();
  }

  _loadCards() async {
    _loaded = false;
    _loaded = await getUserCreditCards();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final cards = ref.watch(creditCardsProvider);

//TODO stringhe
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Carte inserite",
          style: context.textTheme.bodyText2?.copyWith(fontSize: 20),
        ),
        SizedBox(
          height: 200,
          child: (_loaded && cards.isNotEmpty)
              ? ManageCardsWidget(
                  cards: cards,
                  onTap: (cardIndex) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) => EditCreditCardWidget(
                              editCard: cards[cardIndex],
                              onChanged: (card) async {
                                if (card?.id == null) {
                                  await addCreditCard(card!);
                                } else {
                                  await updateCreditCard(card!);
                                }
                                setState(() => _loaded = true);
                              },
                            ));
                  },
                )
              : EmptyCardsWidget(),
        ),
      ],
    );
  }
}
