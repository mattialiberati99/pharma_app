import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../providers/orders_provider.dart';
import 'order_status_tile.dart';

class OrdersRecent extends ConsumerWidget {
  const OrdersRecent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersProv = ref.watch(ordersProvider);
//TODO stringhe
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ordini",
          style: context.textTheme.bodyText2?.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 30,
        ),
        ConstrainedBox(
          //TODO valutare misure layout
          constraints:
              BoxConstraints(maxWidth: context.mqw * 0.90, maxHeight: 330),
          child: ListView.builder(
            itemCount: ordersProv.orders.length,
            itemBuilder: (context, index) {
              return OrderStatusTile(
                order: ordersProv.orders[index],
              );
            },
          ),
        )
      ],
    );
  }
}
