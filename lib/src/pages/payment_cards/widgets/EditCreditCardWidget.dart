
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../../../../generated/l10n.dart';
import '../../../components/AppButton.dart';
import '../../../helpers/app_config.dart';
import '../../../models/credit_card.dart';


class EditCreditCard extends StatefulWidget {
  final CreditCard? editCard;
  final ValueChanged<CreditCard?> onChanged;

  const EditCreditCard(
      {Key? key, this.editCard, required this.onChanged})
      : super(key: key);

  @override
  EditCreditCardWidgetState createState() => EditCreditCardWidgetState();
}

class EditCreditCardWidgetState extends State<EditCreditCard> {
  var editCardKey = GlobalKey<FormState>();
  String numero_carta = '';
  String cvc = '';
  String intestazione = '';
  String expiration = '';

  @override
  void initState() {
      if (widget.editCard != null) {
        numero_carta = widget.editCard!.number;
        intestazione = widget.editCard!.intestazione;
        cvc = widget.editCard!.cvc;
        expiration = "${widget.editCard!.expiration}";
        Future.delayed(
            Duration.zero,
            () => setState(() {
                }));
      }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 60),
      shrinkWrap: true,
      children: [
        CreditCardWidget(
          cardNumber: numero_carta,
          cvvCode: cvc,
          showBackView: false,
          isHolderNameVisible: true,
          expiryDate: expiration,
          cardBgColor: AppColors.mainBlack,
          isSwipeGestureEnabled: false,
          onCreditCardWidgetChange: (newBrand) {},
          cardHolderName: intestazione.toUpperCase(),
        ),
        CreditCardForm(
          formKey: editCardKey,
          onCreditCardModelChange: onCreditCardModelChange,
          themeColor: Colors.red,
          obscureCvv: true,
          isHolderNameVisible: true,
          isCardNumberVisible: true,
          isExpiryDateVisible: true,
          cardNumberDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: S.current.card_number.toUpperCase(),
            hintText: 'XXXX XXXX XXXX XXXX',
          ),
          expiryDateDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: S.current.exp_date.toUpperCase(),
            hintText: 'XX/XX',
          ),
          cvvCodeDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'CVV'.toUpperCase(),
            hintText: 'XXX',
          ),
          cardHolderDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: S.current.card_holder.toUpperCase(),
          ),
          cardNumber: numero_carta,
          cvvCode: cvc,
          expiryDate: expiration,
          cardHolderName: intestazione,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            AppButton(
              buttonText: S.current.action_btn_cancel,
              onPressed: () => widget.onChanged(null),
              color: AppColors.secondDarkColor,
            ),
            AppButton(
              buttonText: S.of(context).save_card,
              onPressed: () async {
                if (editCardKey.currentState!.validate()) {
                  if (widget.editCard?.id != null &&
                      widget.editCard!.id! >= 0) {
                    widget.editCard!.number = numero_carta;
                    widget.editCard!.intestazione = intestazione;
                    widget.editCard!.cvc = cvc;
                    if (expiration.length > 0) {
                      widget.editCard!.expiration = expiration;
                      widget.onChanged(widget.editCard);
                    } else {
                      //setState(() => expireValidate = false);
                    }
                  } else {
                    CreditCard card = new CreditCard();
                    card.number = numero_carta;
                    card.intestazione = intestazione;
                    card.cvc = cvc;
                    print(card.number);
                    if (expiration.length > 0) {
                      card.expiration = expiration;
                      widget.onChanged(card);
                    } else {
                      //setState(() => expireValidate = false);
                    }
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    print("ediiiittt");
    setState(() {
      numero_carta = creditCardModel!.cardNumber;
      expiration = creditCardModel.expiryDate;
      intestazione = creditCardModel.cardHolderName;
      cvc = creditCardModel.cvvCode;
    });
  }
}
