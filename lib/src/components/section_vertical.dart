import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/components/section_header.dart';
import 'package:pharma_app/src/components/shop_card.dart';
import 'package:pharma_app/src/providers/home_cuisines_provider.dart';
import '../providers/shops_provider.dart';

class SectionVertical extends ConsumerWidget {
  final String title;

  final String subTitle;

  const SectionVertical({Key? key, required this.title, required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final best = ref.watch(popularShopsProvider);
    final byCuisine = ref.watch(
        shopsFilteredByCuisineProvider(ref.watch(homeSelectedCuisineProvider)));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(title: title, subTitle: subTitle),
        const SizedBox(
          height: 20,
        ),
        AsyncValueWidget(
            value: byCuisine,
            loading: const CircularProgressIndicator(),
            data: (shopList) {
              final filtered =
                  ref.watch(shopsFilteredByDeliveryProvider(shopList));
              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                clipBehavior: Clip.none,
                scrollDirection: Axis.vertical,
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  return ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 234,
                      ),
                      // child: HomeItemCard(bottomMargin: 24, item: itemsList![index],));
                      child: ShopCard(bottomMargin: 24, shop: filtered[index]));
                },
              );
            })
        //overflow
      ],
    );
  }
}
