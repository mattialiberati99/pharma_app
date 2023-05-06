import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';

import '../../components/async_value_widget.dart';
import '../../components/section_header.dart';
import '../../components/shop_card.dart';
import '../../providers/shops_provider.dart';

class ShopsByAddress extends ConsumerWidget {
  const ShopsByAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(nearestAddressShopsProvider);
    return Scaffold(
        appBar: CustomAppBar(title: "Risultati"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                AsyncValueWidget(
                    value: shops,
                    loading: const CircularProgressIndicator(),
                    data: (shopList) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.vertical,
                        itemCount: shopList.length,
                        itemBuilder: (_, index) {
                          return ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 234,
                              ),
                              // child: HomeItemCard(bottomMargin: 24, item: itemsList![index],));
                              child: ShopCard(
                                  bottomMargin: 24, shop: shopList[index]));
                        },
                      );
                    })
                //overflow
              ],
            ),
          ),
        ));
  }
}
