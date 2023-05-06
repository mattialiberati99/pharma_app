import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/payment_cards/widgets/empty_card_widget.dart';

import '../../../../generated/l10n.dart';
import '../../../components/AppButton.dart';
import '../../../helpers/app_config.dart';
import '../../../models/credit_card.dart';
import '../../../repository/paymentCards_repository.dart';
import '../../payment_cards/widgets/EditCreditCardWidget.dart';

class HorizontalCardList extends StatefulWidget {
  final List<CreditCard> cards;
  final ValueChanged<int>? onTap;
  // final CreditCard? selected;

  const HorizontalCardList({
    Key? key,
    required this.cards,
    this.onTap,
    //this.selected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HorizontalCardListState();
  }
}

class HorizontalCardListState extends State<HorizontalCardList> {
  Key key = new Key(DateTime.now().toString());
  CreditCard? selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.cards.isNotEmpty)
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            key: key,
            itemBuilder: (BuildContext context, int index) {
              final card = widget.cards[index];
              return InkWell(
                onTap: () => {
                  widget.onTap?.call(index),
                  setState(() {
                    selected = card;
                  })
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected == card
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    // color:  card.id == selected?.id ? AppColors.primary : Colors.transparent,
                  ),
                  child: SizedBox(
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CreditCardWidget(
                        cardNumber: card.number,
                        cvvCode: card.cvc,
                        showBackView: false,
                        isHolderNameVisible: true,
                        expiryDate: card.expiration!,
                        // cardBgColor:
                        //     widget.cards[index].id == widget.selected?.id
                        //         ? AppColors.secondColor
                        //         : AppColors.primary,
                        isSwipeGestureEnabled: false,
                        onCreditCardWidgetChange: (newBrand) {},
                        cardHolderName: card.intestazione.toUpperCase(),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.cards.length,
            //index: widget.cards.indexWhere((element) => element.id==widget.selected?.id)??0,
          )
        : EmptyCardsWidget();
  }
}
