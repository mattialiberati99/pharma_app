import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../../generated/l10n.dart';
import '../../../helpers/app_config.dart';
import '../../../models/credit_card.dart';
import '../../../repository/paymentCards_repository.dart';
import 'edit_credit_card_widget.dart';

class ManageCardsWidget extends StatefulWidget {
  final List<CreditCard> cards;
  final ValueChanged<int>? onTap;
  final CreditCard? selected;

  const ManageCardsWidget({
    Key? key,
    required this.cards,
    this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ManageCardsWidgetState();
  }
}

class ManageCardsWidgetState extends State<ManageCardsWidget> {
  CreditCard? editCard;
  Key key = new Key(DateTime.now().toString());
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
            // (widget.cards.length > 0 && editCard == null)?
            Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            key: key,
            itemBuilder: (BuildContext context, int index) {
              final card = widget.cards[index];
              return Dismissible(
                key: UniqueKey(),
                confirmDismiss: (DismissDirection direction) async {
                  return showConfirmDialog(context);
                },
                direction: DismissDirection.endToStart,
                background: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    )),
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
                    cardBgColor: widget.cards[index].id == widget.selected?.id
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
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 12.0),
        //   child: AppButton(
        //     buttonText: S.current.add,
        //     onPressed: () => setState(() {
        //       editCard = new CreditCard();
        //     }),
        //   ),
        // )
      ],
    )
        // : EditCreditCardWidget(
        //     editCard: editCard,
        //     onChanged: (card) async {
        //       if (card != null) {
        //         if (card.id == null) {
        //           await addCreditCard(card);
        //         } else {
        //           await updateCreditCard(card);
        //         }
        //       }
        //       setState(() {
        //         editCard = null;
        //         key = new Key(DateTime.now().toString());
        //       });
        //     }),
        );
  }

  Future<bool?> showConfirmDialog(
    BuildContext context, {
    String? title,
    String? subTitle,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title ?? context.loc.dialog_title,
            textAlign: TextAlign.center,
          ),
          content: Text(
            subTitle ?? context.loc.dialog_subtitle_card,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmText ?? context.loc.dialog_delete,
                textAlign: TextAlign.center,
                style: context.textTheme.subtitle2
                    ?.copyWith(color: context.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText ?? context.loc.dialog_cancel,
                  style: context.textTheme.subtitle2
                      ?.copyWith(color: context.colorScheme.secondary)),
            ),
          ],
        );
      },
    );
  }
}
