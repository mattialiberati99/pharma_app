import 'package:flutter/material.dart';

import '../../../components/empty_widget.dart';


class EmptyCardsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
        text: "Nessuna carta inserita",
        icon: Icons.credit_card,
        action: Text(
          "Aggiungi Carta",
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
        )
    );
  }
}
