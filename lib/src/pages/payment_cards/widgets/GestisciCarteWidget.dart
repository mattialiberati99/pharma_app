import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../../generated/l10n.dart';
import '../../../components/AppButton.dart';
import '../../../helpers/app_config.dart';
import '../../../models/credit_card.dart';
import '../../../repository/paymentCards_repository.dart';
import 'EditCreditCardWidget.dart';

class GestisciCarteWidget extends StatefulWidget {
  final List<CreditCard> cards;
  final ValueChanged<int>? onTap;
  final CreditCard? selected;

  const GestisciCarteWidget({
    Key? key,
    required this.cards,
    this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GestisciCarteWidgetState();
  }
}

class GestisciCarteWidgetState extends State<GestisciCarteWidget> {
  CreditCard? editCard;
  Key key = new Key(DateTime.now().toString());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (widget.cards.length > 0 && editCard == null)
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    key: key,
                    itemBuilder: (BuildContext context, int index) {
                      final card = widget.cards[index];
                      return Dismissible(
                        key: Key(card.id!.toString()),
                        onDismissed: (dir) => setState(() {
                          removeCreditCard(card);
                          widget.cards.remove(card);
                        }),
                        child: InkWell(
                          onTap: () => widget.onTap?.call(index),
                          child: CreditCardWidget(
                            cardNumber: card.number,
                            cvvCode: card.cvc,
                            showBackView: false,
                            isHolderNameVisible: true,
                            expiryDate: card.expiration!,
                            cardBgColor:
                                widget.cards[index].id == widget.selected?.id
                                    ? AppColors.mainBlack
                                    : AppColors.secondDarkColor,
                            isSwipeGestureEnabled: false,
                            onCreditCardWidgetChange: (newBrand) {},
                            cardHolderName: card.intestazione.toUpperCase(),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.cards.length,
                    //index: widget.cards.indexWhere((element) => element.id==widget.selected?.id)??0,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: PrimaryNoSizedButton(
                        label: S.current.card_new,
                        hMargin: 50,
                        onPressed: () => setState(() {
                              editCard = CreditCard();
                            }),
                        height: context.onSmallScreen ? 40 : 60))
              ],
            )
          : EditCreditCard(
              editCard: editCard,
              onChanged: (card) async {
                if (card != null) {
                  if (card.id == null) {
                    await addCreditCard(card);
                  } else {
                    await updateCreditCard(card);
                  }
                }
                setState(() {
                  editCard = null;
                  key = new Key(DateTime.now().toString());
                });
              }),
    );
  }
}
