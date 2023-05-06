import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/home_cuisines_provider.dart';

import '../../../components/async_value_widget.dart';
import '../../../helpers/helper.dart';
import '../../../providers/cuisines_provider.dart';
import 'drop_chip.dart';

class MacroCategoriesMenu extends ConsumerWidget {
  final String? cuisineSelected;
  final Function onCuisineSelected;

  const MacroCategoriesMenu(
      {required this.cuisineSelected,
      required this.onCuisineSelected,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuisinesForMenu = ref.watch(preHomeCuisinesProvider);

    final nSize = context.mqw * 0.25;
    final lSize = context.mqw * 0.28;
    // final double rad = radians(30);
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: context.mqw,
          minHeight: context.mqh * 0.5,
          maxHeight:
              context.onSmallScreen ? context.mqh * 0.75 : context.mqh * 0.6),
      child: AsyncValueWidget(
        value: cuisinesForMenu,
        loading: const Center(child: CircularProgressIndicator()),
        data: (cuisines) {
          return Stack(
              fit: StackFit.passthrough,
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: List.generate(cuisines.length, (int index) {
                final cuisine = cuisines[index];
                final positions = {
                  0: const Alignment(0, 0), // tutto
                  1: Alignment(0, 0.65), //Sconti
                  2: const Alignment(-0.9, 0.30), //Dolci
                  3: const Alignment(-0.9, -0.30), //Spesa
                  4: const Alignment(0, -0.65), //Shopping
                  5: const Alignment(0.9, -0.30), //Farmacie
                  6: const Alignment(0.9, 0.30) //Ristoranti
                };
                return Align(
                  alignment: positions.values.elementAt(index),
                  child: SizedBox(
                    //necessario per permettere il corretto allinemento su asse y
                    width: index == 0 ? lSize : nSize,
                    height: index == 0 ? lSize : nSize,
                    child: DropChip(
                      label: Helper.skipHtml(
                        cuisines[index].description!,
                      ),
                      hasBorder: true,
                      selected: cuisineSelected == cuisine.id,
                      iconPath: cuisines[index].image!.url!,
                      size: index == 0 ? lSize : nSize,
                      iconSize: 44,
                      onSelected: () => onCuisineSelected(cuisine),
                    ),
                  ),
                );
              }));
        },
      ),
    );
  }
}
