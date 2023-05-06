import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'package:pharma_app/src/providers/shops_provider.dart';
import 'package:pharma_app/src/repository/favorite_repository.dart';

import '../../../helpers/app_config.dart';
import '../../../models/shop_favorite.dart';
import '../../../providers/favorites_provider.dart';

class ShopBar extends ConsumerStatefulWidget {
  const ShopBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ShopBar> createState() => _ShopBarState();
}

class _ShopBarState extends ConsumerState<ShopBar> {
  ShopFavorite? isFavorite;

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final asyncShop = ref.watch(currentShopProvider);
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        OutlinedButton(
            //TODO riutilizzare
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              backgroundColor:
                  MaterialStateProperty.all(context.colorScheme.onPrimary),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Color(0xFF333333),
              ),
            )),
        Spacer(),
        Container(
          //TODO riutilizzare
          decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(85),
                  bottomLeft: Radius.circular(85),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              )),
          height: 48,
          width: 168,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AsyncValueWidget(
                value: asyncShop,
                data: (shop) {
                  isFavorite = favorites.getShopFavorite(shop!);
                  return GestureDetector(
                    onTap: () async {
                      if (isFavorite != null) {
                        if (await removeShopFavorite(isFavorite!)) {
                          favorites.delShop(isFavorite!);
                          setState(() {});
                        }
                      } else {
                        final favorite = await addShopFavorite(shop);
                        if (favorite != null) {
                          favorites.addShop(favorite);
                        }
                        setState(() {});
                      }
                    },
                    child: Icon(
                        isFavorite != null
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            isFavorite != null ? Colors.red : AppColors.gray4),
                  );
                },
              ),
              const SizedBox(
                width: 35,
              ),
              GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('Cart'),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: context.colorScheme.primary,
                      ),
                      Positioned(
                        top: -5,
                        right: -3,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: ShapeDecoration(
                              color: context.colorScheme.primary,
                              shape: const CircleBorder()),
                          child: Center(
                              child: Text(
                            ref.watch(cartProvider).count.toString(),
                            textAlign: TextAlign.center,
                            style: context.textTheme.subtitle2?.copyWith(
                                fontSize: 9, color: AppColors.lightBlack1),
                          )),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        )
      ],
    );
  }
}
