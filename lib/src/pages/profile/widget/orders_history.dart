import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import 'order_history_tile.dart';

class OrdersHistory extends StatefulWidget {
  const OrdersHistory({Key? key}) : super(key: key);

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//TODO stringhe
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Storico ordini",
          style: context.textTheme.bodyText2?.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 30,
        ),
        ConstrainedBox(
          //TODO valutare misure layout
          constraints:
              BoxConstraints(maxWidth: context.mqw * 0.90, maxHeight: 320),
          child: ListView(
            shrinkWrap: true,
            children: const [
              OrderHistoryTile(
                  title: '#09132005', subtitle: '1 articoli', delivered: true),
              OrderHistoryTile(
                  title: '#09132005', subtitle: '2 articoli', delivered: true),
              OrderHistoryTile(
                  title: '#09132005', subtitle: '3 articoli', delivered: true),
              OrderHistoryTile(
                  title: '#09132006', subtitle: '2 articoli', delivered: true),
              OrderHistoryTile(
                  title: '#09132007', subtitle: '5 articoli', delivered: false),
              OrderHistoryTile(
                  title: '#09132008', subtitle: '3 articoli', delivered: false)
            ],
          ),
        )
      ],
    );
  }
}
