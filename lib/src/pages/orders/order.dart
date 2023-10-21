import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/bottomNavigation.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/models/media.dart';
import 'package:pharma_app/src/providers/notification_provider.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';

// ignore: must_be_immutable
class OrderP extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final notificationProv = ref.watch(notificationProvider);
    return Scaffold(
      bottomNavigationBar: BottomNavigation(sel: SelectedBottom.ordini),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new)),
                    const Text(
                      'I miei ordini',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
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
              if (orders.orders.isEmpty)
                ...orders.orders.map(
                  (e) => Container(
                    child: Column(children: [
                      Row(
                        children: [
                          Container(
                            color: Color.fromARGB(255, 242, 243, 243),
                            child: Image(
                                width: 77,
                                height: 88,
                                image: NetworkImage(
                                    e.foodOrders.first.food!.image!.url!)),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    e.foodOrders.first.food!.name!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Image(
                                        image: AssetImage(
                                            'assets/immagini_pharma/delOrd.png'),
                                      ))
                                ],
                              ),
                              Text(
                                e.foodOrders.first.food!.ingredients!,
                                style: const TextStyle(
                                  color: Color.fromARGB(115, 9, 15, 71),
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Ordine n° ${e.id}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    e.orderStatus!.status! == 'In Consegna'
                                        ? '${e.orderStatus!.status!}il: ${e.consegna!.toIso8601String()}'
                                        : e.orderStatus!.status!,
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ]),
                  ),
                ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
