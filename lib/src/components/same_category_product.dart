import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/section_header.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/categories_provider.dart';
import 'package:pharma_app/src/providers/food_provider.dart';

import '../providers/shops_provider.dart';
import 'async_value_widget.dart';
import 'shop_card_horizontal.dart';

class SameCategoryProduct extends ConsumerWidget {
  final String categoryNumber;
  final String title;
  final String subTitle;
  final String excludedProductId; //ID del prodotto da escludere

  const SameCategoryProduct(
      {Key? key,
      required this.categoryNumber,
      required this.title,
      required this.subTitle,
      required this.excludedProductId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosen = ref.watch(farmaOfCategoryProvider(categoryNumber));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 28, 31, 30),
                  fontWeight: FontWeight.w600),
            ),
            Text(
              subTitle,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 28, 31, 30),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        AsyncValueWidget(
            value: chosen,
            loading: const CircularProgressIndicator(),
            data: (chosenShops) {
              final filteredShops = chosenShops
                  .where((product) => product.id != excludedProductId)
                  .toList();

              return Container(
                height: 171,
                width: 174,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredShops.length,
                  itemBuilder: (_, index) {
                    return FarmacoCardHorizontal(
                      farmaco: filteredShops[index],
                    );
                  },
                ),
              );
            }),
      ],
    );
  }
}
