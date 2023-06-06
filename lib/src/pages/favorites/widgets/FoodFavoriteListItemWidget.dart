import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../helpers/app_config.dart';
import '../../../helpers/helper.dart';
import '../../../models/extra.dart';
import '../../../models/food_favorite.dart';
import '../../../models/route_argument.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../../repository/favorite_repository.dart';
import '../../../repository/food_repository.dart';

// ignore: must_be_immutable
class FoodFavoriteListItemWidget extends ConsumerWidget {
  String heroTag;
  FarmacoFavorite favorite;

  FoodFavoriteListItemWidget(
      {Key? key, required this.heroTag, required this.favorite})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final favorites = ref.watch(favoritesProvider);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed('Food', arguments: RouteArgument(model: favorite.food!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Image
          SizedBox(
            width: MediaQuery.of(context).size.width * .3,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: CachedNetworkImage(
                imageUrl: favorite.food!.image!.thumb!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Image.asset('assets/img/loading.gif'),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(width: 10),

          /// All the rest
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Shop name

                /// Product name
                Text(
                  favorite.food!.name!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: Colors.black),
                ),

                /// Last row
                Helper.getPrice(
                  favorite.food!.price!,
                  context,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      if (await removeFarmacoFavorite(favorite)) {
                        favorites.delFarmaco(favorite);
                      }
                    },
                    icon: SvgPicture.asset('assets/ico/trash.svg')),
                SizedBox(
                  height: 8,
                ),
                IconButton(
                    onPressed: () {
                      cart.add(favorite.food!, 1, []);
                    },
                    icon: SvgPicture.asset('assets/ico/addtocart.svg'))
              ]),
        ],
      ),
    );
  }
}
