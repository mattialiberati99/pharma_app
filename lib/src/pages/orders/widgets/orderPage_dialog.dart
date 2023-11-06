import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../providers/acquistiRecenti_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../cart/check.dart';

class OrderPageDialog extends StatefulWidget {
  final CartProvider cartProv;
  final OrdersProvider orderProv;
  final AcquistiRecentiProvider acquistiRecentiProv;
  final ChatProvider chatProv;

  OrderPageDialog({
    required this.cartProv,
    required this.orderProv,
    required this.acquistiRecentiProv,
    required this.chatProv,
  });

  @override
  _OrderPageDialogState createState() => _OrderPageDialogState();
}

class _OrderPageDialogState extends State<OrderPageDialog> {
  bool isPaymentInProgress = false;

  void updatePaymentInProgress(bool value) {
    setState(() {
      isPaymentInProgress = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Conferma'),
      content: Text('Conferma il pagamento con la carta selezionata?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annulla'),
        ),
        isPaymentInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  updatePaymentInProgress(true);
                  await finalizeOrder(
                      widget.cartProv, widget.orderProv, widget.acquistiRecentiProv, widget.chatProv, context, 'Carta');
                  updatePaymentInProgress(false);
                },
                child: const Text('Paga'),
              ),
      ],
    );
  }
}
