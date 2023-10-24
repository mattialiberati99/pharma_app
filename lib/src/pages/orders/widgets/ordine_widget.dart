import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/app_config.dart';

import '../../../models/food_order.dart';
import '../../../models/order.dart';

class OrdineTab extends ConsumerWidget {
  final FarmacoOrder farmacoOrder;
  final Order order;
  const OrdineTab(this.farmacoOrder, this.order);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed('Product', arguments: farmacoOrder.product),
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    color: const Color.fromARGB(255, 242, 243, 243),
                    child: Image(
                      width: 77,
                      height: 88,
                      image: NetworkImage(farmacoOrder.product!.image!.url!),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            farmacoOrder.product!.name.toString(),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 9, 15, 71),
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          // TODO : Delete button
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Text(
                            'Ordine n° ${order.id}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            order.orderStatus!.status!,
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
