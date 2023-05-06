import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/providers/position_provider.dart';
import 'package:pharma_app/src/providers/shops_provider.dart';
import 'package:pharma_app/src/repository/products_repository.dart';

import '../models/farmaco.dart';
import '../repository/food_repository.dart';
import 'home_cuisines_provider.dart';

final filteredProductList = FutureProvider.family((ref, String search) async {
  return searchFarmacos(search, address: PositionProvider.currentAddress);
});

/// Shop Items filtered by category
final shopProductsProvider =
    FutureProvider.autoDispose.family((ref, String categoryId) async {
  final shopId = ref.watch(currentShopIDProvider);
  if (kDebugMode) {
    print('Current SHOP ID: $shopId');
  }
  final itemsOfShopByCategory = await getProductsOfShop(shopId, categoryId);
  // print('ITEMS: $itemsOfShopByCategory');
  return itemsOfShopByCategory;
});

/// Home Items filtered by category & inEvidenza true
final productsProvider = FutureProvider((ref) async {
  final selectedHomeCategory = ref.watch(homeSelectedCuisineProvider);
  print('HOME CUISINE: $selectedHomeCategory');
  final itemsOfSelectedCategory =
      await getProductsByCategory(selectedHomeCategory, inEvidenza: true);
  print('ITEMS IN: $selectedHomeCategory - ${itemsOfSelectedCategory.length}');
  return itemsOfSelectedCategory;
});

final currentProductProvider = StateProvider<Farmaco?>((ref) => null);

// /// Home Items filtered by category
// final itemsProvider = FutureProvider((ref) async {
//   final Map<String,Farmaco> foods = {};
//   final selectedHomeCategory = '11';
//   print('HOME CATEGORY: $selectedHomeCategory');
//   final itemsOfSelectedCategory =  await getFarmacosByCategory(selectedHomeCategory);
//   foods.addEntries(itemsOfSelectedCategory.map((e) => MapEntry(e.id!, e)));
//   print('ITEMS IN: $selectedHomeCategory ${foods.values.toList()}');
//   return foods;
// });