import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/shadow_box.dart';
import '../../../helpers/app_config.dart';
import '../../../helpers/helper.dart';

import '../../../models/route_argument.dart';
import '../../../models/shop.dart';
import '../../../models/shop_favorite.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/shops_provider.dart';
import '../../../repository/favorite_repository.dart';
import '../../../repository/restaurant_repository.dart';

class HomePopularRestaurantItemWidget extends ConsumerWidget {
  final Shop farmacia;

  const HomePopularRestaurantItemWidget({Key? key, required this.farmacia})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProv = ref.watch(favoritesProvider);
    ShopFavorite? isFavorite = favoriteProv.getShopFavorite(farmacia);

    return GestureDetector(
      onTap: () {
        recentRestaurants.value.add(farmacia.id!);
        saveRecentRestaurants();
        ref.invalidate(recentRestaurantsProvider);
        Navigator.of(context)
            .pushNamed('Ristorante', arguments: RouteArgument(model: farmacia));
      },
      child: ShadowBox(
          hMargin: 12,
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 160,
                      maxHeight: 160,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      child: Image.network(
                        farmacia.image!.url!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, top: 8, bottom: 8),
                    child: Text(
                      farmacia.name ?? '',
                      //style: TextStyle.mediumBlackRegular,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            if (isFavorite != null) {
                              if (await removeShopFavorite(isFavorite)) {
                                favoriteProv.delShop(isFavorite);
                              }
                            } else {
                              final favorite = await addShopFavorite(farmacia);
                              if (favorite != null) {
                                favoriteProv.addShop(favorite);
                              }
                            }
                          },
                          child: SvgPicture.asset(isFavorite != null
                              ? 'assets/img/fav.svg'
                              : 'assets/img/fav_add.svg'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                  top: 8,
                  right: 12,
                  child: Row(
                    children: [
                      ...Helper.getStarsList(
                        5,
                        size: 20,
                      )
                    ],
                  )),
            ],
          )),
    );
  }
}
