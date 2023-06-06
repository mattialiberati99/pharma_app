import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/pages/categorie+/categorie.dart';
import 'package:pharma_app/src/pages/favorites/widgets/EmptyFavoritesWidget.dart';

import '../../../generated/l10n.dart';

import '../../components/PermissionDeniedWidget.dart';
import '../../components/custom_app_bar.dart';
import 'widgets/FoodFavoriteListItemWidget.dart' as farmaco;
import '../../providers/favorites_provider.dart';
import '../../providers/user_provider.dart';

class FavoritesWidget extends ConsumerWidget {
  ///Da cambiare per scegliere cosa mostrare
  final bool showFood = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Preferiti',
        rightWidget: Container(),
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : RefreshIndicator(
              onRefresh: favorites.loadFavorites,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: buildFavoriteList(favorites.foodFavorites, showFood)),
            ),
    );
  }

  Widget buildFavoriteList(favorites, showFood) {
    return favorites.isEmpty
        ? EmptyFavoritesWidget()
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return showFood
                  ? farmaco.FoodFavoriteListItemWidget(
                      heroTag: 'favorites_list',
                      favorite: favorites.elementAt(index),
                    )
                  : FarmacoCategoria(
                      farmaco: favorites.elementAt(index).food,
                      scount: 0,
                    );
            },
          );
  }
}
