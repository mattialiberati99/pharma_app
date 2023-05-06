import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/shop_favorite.dart';
import 'package:pharma_app/src/pages/favourites/widgets/favorite_shop_grid_item.dart';
import 'package:pharma_app/src/repository/favorite_repository.dart';

import '../../components/async_value_widget.dart';
import '../../components/drawer/app_drawer.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/selected_page_name_provider.dart';
import '../../providers/shops_provider.dart';

class Favorite extends ConsumerStatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  ConsumerState<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends ConsumerState<Favorite> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final favorites = ref.watch(favoritesProvider);
    final favorite = ref.watch(favoriteShopsProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop;
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(title: "Preferiti"),
        drawer: const AppDrawer(),
        drawerEnableOpenDragGesture: true,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SingleChildScrollView(
                controller: scrollController,
                child: SizedBox(
                  height: context.mqh,
                  width: context.mqw,
                  child: AsyncValueWidget(
                    value: favorite,
                    loading: const Center(child: CircularProgressIndicator()),
                    data: (favoriteShops) {
                      return RefreshIndicator(
                        onRefresh: () =>
                            ref.refresh(favoriteShopsProvider.future),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                context.onSmallScreen ? 0.72 : 0.80,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            if (index < favoriteShops.length) {
                              return FavoriteShopGridItem(
                                  onPressed: () => removeFromFavorites(
                                      favoriteShops, index, favorites),
                                  favorite: favoriteShops[index]);
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
                          itemCount: favoriteShops.length.isEven
                              ? favoriteShops.length
                              : favoriteShops.length + 1,
                          // Aggiunge un elemento se i negozi sono dispari in modo da avere lo spazio sempre riempito
                        ),
                      );
                    },
                  ),
                )),
          ),
        )),
      ),
    );
  }

  Future<void> removeFromFavorites(List<ShopFavorite> favoriteShops, int index,
      FavoritesProvider favorites) async {
    if (await removeShopFavorite(favoriteShops[index])) {
      favorites.delShop(favoriteShops[index]);
    }
    ref.refresh(favoriteShopsProvider.future);
  }
}
