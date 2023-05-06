import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:pharma_app/src/components/secondary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../../generated/l10n.dart';
import '../../../components/primary_nosized_button.dart';
import '../../../helpers/app_config.dart';
import '../../../models/credit_card.dart';

class EditCreditCardWidget extends StatefulWidget {
  final CreditCard? editCard;
  final ValueChanged<CreditCard?> onChanged;

  const EditCreditCardWidget({Key? key, this.editCard, required this.onChanged})
      : super(key: key);

  @override
  EditCreditCardWidgetState createState() => EditCreditCardWidgetState();
}

class EditCreditCardWidgetState extends State<EditCreditCardWidget> {
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
      Future.delayed(Duration.zero, () => setState(() {}));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
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
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.onSmallScreen ? 24.0 : 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SecondaryNoSizedButton(
                      label: S.current.action_btn_cancel,
                      hMargin: 16,
                      onPressed: () {
                        //widget.onChanged(null);
                        Navigator.of(context).pop();
                      },
                      height: 55),
                ),
                Expanded(
                  child: PrimaryNoSizedButton(
                      label: S.of(context).save_card,
                      hMargin: 16,
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
                              Navigator.of(context).pop();
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
                              Navigator.of(context).pop();
                            } else {
                              //setState(() => expireValidate = false);
                            }
                          }
                        }
                      },
                      height: 55),
                ),
              ],
            ),
          ),
        ],
      ),
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
