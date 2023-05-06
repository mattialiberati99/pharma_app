// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/models/farmaco.dart';

// Project imports:
import '../models/food_favorite.dart';
import '../models/shop.dart';
import '../models/shop_favorite.dart';
import '../repository/favorite_repository.dart';

final favoritesProvider =
    ChangeNotifierProvider.autoDispose<FavoritesProvider>((ref) {
  return FavoritesProvider();
});

class FavoritesProvider with ChangeNotifier {
  List<FarmacoFavorite> foodFavorites = [];
  List<ShopFavorite> shopFavorites = [];

  FavoritesProvider() {
    loadFavorites();
  }

  addFarmaco(FarmacoFavorite favorite) {
    if (foodFavorites.where((element) => favorite.id == element.id).isEmpty)
      foodFavorites.add(favorite);
    print(foodFavorites.length);
    notifyListeners();
  }

  addAllFarmacos(List<FarmacoFavorite> favorites) {
    foodFavorites.addAll(favorites);
  }

  delFarmaco(FarmacoFavorite favorite) {
    foodFavorites.remove(favorite);
    print(foodFavorites.length);
    notifyListeners();
  }

  delFarmacoAt(int index) {
    foodFavorites.removeAt(index);
    notifyListeners();
  }

  removeFarmacoId(String id) {
    foodFavorites.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  addShop(ShopFavorite favorite) {
    if (shopFavorites.where((element) => favorite.id == element.id).isEmpty) {
      shopFavorites.add(favorite);
      print("added");
    }
    print(shopFavorites.length);
    notifyListeners();
  }

  addAllShops(List<ShopFavorite> favorites) {
    shopFavorites.addAll(favorites);
  }

  delShop(ShopFavorite favorite) {
    shopFavorites.remove(favorite);
    print(shopFavorites.length);
    notifyListeners();
  }

  delShopAt(int index) {
    shopFavorites.removeAt(index);
    notifyListeners();
  }

  removeShopId(String id) {
    shopFavorites.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  clear() {
    foodFavorites.clear();
    shopFavorites.clear();
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    foodFavorites = await getFarmacoFavorites();
    shopFavorites = await getShopFavorites();
    notifyListeners();
  }

  FarmacoFavorite? getFarmacoFavorite(Farmaco food) {
    final where = foodFavorites.where((element) => element.food == food);
    return where.isNotEmpty ? where.first : null;
  }

  ShopFavorite? getShopFavorite(Shop restaurant) {
    final where = shopFavorites.where((element) {
      print(element.restaurant?.id);
      return element.restaurant?.id == restaurant.id;
    });
    return where.isNotEmpty ? where.first : null;
  }
}
