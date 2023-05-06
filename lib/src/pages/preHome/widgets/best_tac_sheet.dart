import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/preHome/widgets/shop_grid_item.dart';
import 'package:pharma_app/src/providers/shops_provider.dart';

import '../../../components/async_value_widget.dart';

class BestTacSheet extends ConsumerWidget {
  const BestTacSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final best = ref.watch(popularShopsProvider);

    final initialChildSize = (context.mqh * 0.055) / (context.mqh);
    final minChildSize = (context.mqh * 0.055) / (context.mqh);
    const maxChildSize = 1.0;

    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      snap: true,
      snapSizes: [minChildSize, 0.43, 0.86],
      builder: (BuildContext context, ScrollController scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Center(
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      )),
                  child: SizedBox(
                      height: context.mqh * 0.055,
                      width: context.mqw * 0.175,
                      child: Center(
                          child: Icon(
                        Icons.expand_more,
                        color: context.colorScheme.primary,
                      ))),
                ),
              ),
            ),
            const SliverPersistentHeader(
              delegate: HeaderDelegate(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 50),
              //Necessario per avere la possibiltà di effettuare lo scroll fino all'ultimo elemento di SliverGrid
              sliver:
                  Consumer(builder: (BuildContext context, WidgetRef ref, _) {
                return AsyncValueWidget(
                    value: best,
                    loading: const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    data: (bestShops) => SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.75,
                            crossAxisCount: 2,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (index < bestShops.length) {
                                return ShopGridItem(shop: bestShops[index]);
                              } else {
                                //Aggiungo uno spazio binaco per riempire il vuoto dopo l'ultimo item con indice dispari
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                        width: context.mqw * 0.5,
                                        top: -2,
                                        bottom: -50,
                                        child: Container(
                                          color: Colors.white,
                                        )),
                                    // Container(
                                    //   color: Colors.white,
                                    // ),
                                  ],
                                );
                              }
                            },
                            childCount: bestShops.length.isEven
                                ? bestShops.length
                                : bestShops.length + 1,
                            // Aggiunge un elemento se i negozi sono dispari in modo da avere lo spazio sempre riempito
                          ),
                        ));
              }),
            ),
          ],
        );
      },
    );
  }
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  const HeaderDelegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: Text('I migliori Tac',
              style: context.textTheme.subtitle1?.copyWith(fontSize: 20)),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 55;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
