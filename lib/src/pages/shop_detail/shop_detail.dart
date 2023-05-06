import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/components/footer_actions.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/shop.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/product_tile.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/shop_bar.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/shop_header.dart';
import 'package:pharma_app/src/providers/can_add_provider.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'package:pharma_app/src/providers/categories_provider.dart';

import '../../helpers/app_config.dart';
import '../../models/extra.dart';
import '../../providers/products_provider.dart';

class ShopDetail extends ConsumerWidget {
  final Shop shop;

  const ShopDetail({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        shop.image!.url!,
                      )
                      //AssetImage('assets/immagini/cover_dettaglio.png')
                      )),
              child: SizedBox(
                width: context.mqw,
                height: context.mqh * 0.4,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: context.mqh * 0.065,
            child: const ShopBar(),
          ),
          Positioned(bottom: 0, child: ShopContent(shop: shop))
        ],
      ),
      bottomNavigationBar: FooterActions(
        //TODO stringhe e totale dinamico
        firstLabel: ref.watch(canAddProvider)
            ? '${context.loc.action_btn_order} ${cart.total.toEUR()}'
            : context.loc.action_order,
        firstAction: () => ref.watch(canAddProvider)
            ? Navigator.of(context).pushNamed('Cart')
            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Non puoi ordinare da più negozi contemporaneamente'),
                action: SnackBarAction(
                  onPressed: () => Navigator.of(context).pushNamed('Cart'),
                  label: 'Vai al carrello',
                ),
              )),
        // onPressed: () {
        //   if (taglia != null || food.taglie.isEmpty) {
        //     List<Extra> cartExtras = [];
        //     if (pietra != null) cartExtras.add(pietra!);
        //     if (materiale != null) cartExtras.add(materiale!);
        //     if (taglia != null) cartExtras.add(taglia!);
        //     cartProv.add(food, quantity, cartExtras);
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content:
        //       Text(S.current.this_food_was_added_to_cart),
        //       action: SnackBarAction(
        //         onPressed: () =>
        //             Navigator.of(context).pushNamed('Cart'),
        //         label: S.current.cart.toUpperCase(),
        //       ),
        //     ));
        //   } else {
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text(
        //         S.current.select_taglia,
        //       ),
        //     ));
        //   }
        // },
        hasSecond: false,
        hasNote: true,
      ),
    );
  }
}

class ShopContent extends ConsumerStatefulWidget {
  const ShopContent({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  ConsumerState<ShopContent> createState() => _ShopContentState();
}

class _ShopContentState extends ConsumerState<ShopContent>
    with AutomaticKeepAliveClientMixin<ShopContent> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(
    BuildContext context,
  ) {
    super.build(context);

    final productsCategories =
        ref.watch(categoriesOfShopProvider(widget.shop.id!));
    final shopCategories = productsCategories.value;
    final cart = ref.watch(cartProvider);

    final canAdd = ref.watch(canAddProvider);

    return AsyncValueWidget(
        value: productsCategories,
        data: (categories) {
          return DefaultTabController(
            length: categories.length,
            child: ShadowBox(
              topRightRadius: 30,
              topLeftRadius: 30,
              bottomRightRadius: 0,
              bottomLeftRadius: 0,
              color: Colors.white,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: context.mqh * 0.80, maxWidth: context.mqw),
                  child: SizedBox.expand(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: context.mqw * 0.08),
                      child: Column(
                        children: [
                          ShopHeader(
                            shop: widget.shop,
                          ),
                          TabBar(
                            padding: EdgeInsets.zero,
                            isScrollable: true,
                            indicatorColor: AppColors.primary,
                            labelStyle: context.textTheme.bodyText1,
                            labelColor: AppColors.gray1,
                            unselectedLabelColor: AppColors.gray4,
                            tabs: [
                              ...List.generate(
                                categories.length,
                                (index) => Tab(
                                    text:
                                        categories[index].name?.toUpperCase()),
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: AppColors.gray5))),
                                child: TabBarView(children: <Widget>[
                                  ...List.generate(
                                      shopCategories!.length,
                                      (index) => AsyncValueWidget(
                                          value: ref.watch(shopProductsProvider(
                                              shopCategories[index].id!)),
                                          data: (productList) {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              clipBehavior: Clip.none,
                                              scrollDirection: Axis.vertical,
                                              itemCount: productList.length,
                                              itemBuilder: (_, index) {
                                                return ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxHeight: 234,
                                                    ),
                                                    child: ProductTile(
                                                      product:
                                                          productList[index],
                                                      onAdd: () {
                                                        List<Extra> cartExtras =
                                                            [];
                                                        canAdd
                                                            ? cart.add(
                                                                productList[
                                                                    index],
                                                                1,
                                                                cartExtras)
                                                            : ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                content: //TODO stringhe
                                                                    Text(
                                                                        'Non puoi ordinare da più negozi contemporaneamente'),
                                                                action:
                                                                    SnackBarAction(
                                                                  onPressed: () => Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          'Cart'),
                                                                  label:
                                                                      'Vai al carrello',
                                                                ),
                                                              ));
                                                        print(
                                                            'Totale: ${cart.total}');
                                                      },
                                                      onRemove: () {
                                                        List<Extra> cartExtras =
                                                            [];
                                                        if (cart.total != 0) {
                                                          cart.decrease(
                                                              productList[
                                                                  index],
                                                              cartExtras);
                                                          print(
                                                              'Totale: ${cart.total}');
                                                        }
                                                      },
                                                    ));
                                              },
                                            );
                                          }))
                                ])),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }
}
