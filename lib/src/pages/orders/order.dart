import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/bottomNavigation.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/models/media.dart';
import 'package:pharma_app/src/pages/orders/widgets/ordine_widget.dart';
import 'package:pharma_app/src/providers/notification_provider.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';

import '../../../main.dart';

class OrderP extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final notificationProv = ref.watch(notificationProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavigation(sel: SelectedBottom.ordini),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const Text(
                    'I miei ordini',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('Cart');
                      },
                      child: notificationProv.notifications.isNotEmpty
                          ? const Image(
                              image: AssetImage(
                                  'assets/immagini_pharma/Icon_shop_noti.png'))
                          : const Image(
                              image: AssetImage(
                                  'assets/immagini_pharma/Icon_shop.png')),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 25, top: 25),
              child: Text(
                '${orders.orders.length} articoli ordinati',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(115, 9, 15, 71),
                ),
              ),
            ),
            if (orders.orders.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(),
                itemCount: orders.orders.length,
                itemBuilder: (ctx, i) {
                  logger.info('INDICE: $i');
                  logger.info('ID ORDINE: ${orders.orders[i].id}');

                  return OrdineTab(
                      orders.orders[i].foodOrders[0], orders.orders[i]);
                },
              ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
