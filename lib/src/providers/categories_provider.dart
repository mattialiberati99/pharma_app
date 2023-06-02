// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/category.dart';
import '../models/farmaco.dart';
import '../repository/category_repository.dart' as categoryRepo;
import '../repository/food_repository.dart';

final categoriesProvider = ChangeNotifierProvider<CategoriesProvider>((ref) {
  return CategoriesProvider();
});

/// Provider for Categories of a Shop
final categoriesOfShopProvider =
    FutureProvider.family<List<AppCategory>, String>((ref, shopId) async {
  return await categoryRepo.getCategoriesOfRestaurant(shopId);
});

class CategoriesProvider with ChangeNotifier {
  Map<String, AppCategory> categories = {};
  Map<String, AppCategory> otherCategories = {};
  List<Farmaco> farmaciOfCate = [];

  CategoriesProvider() {
    Future.delayed(Duration.zero, () async {
      addAll(await categoryRepo.getCategories());
      if (otherCategories.isEmpty) {
        otherCategories.addAll(categories);
      }
    });
  }

  add(AppCategory category) {
    try {
      categories[category.id] != null;
    } catch (e) {
      categories[category.id!] = category;
    }
    notifyListeners();
  }

  addAll(List<AppCategory> categories) {
    this.categories.addEntries(categories.map((e) => MapEntry(e.id!, e)));
    notifyListeners();
  }

  del(AppCategory category) {
    categories.remove(category.id);
    notifyListeners();
  }

  clear() {
    categories.clear();
    notifyListeners();
  }

  addAllFarm(List<Farmaco> farmaci) {
    farmaciOfCate.addAll(farmaci);
    notifyListeners();
  }

  getFarmaOfCate(String cateId) async {
    farmaciOfCate.clear();
    addAllFarm(await getFarmacosOfCategory(cateId));
    notifyListeners();
  }

  final farmaOfCategoryProv =
      FutureProvider.family<List<Farmaco>, String>((ref, categoryId) async {
    return await getFarmacosByCategory(categoryId);
  });

  Future<List<Farmaco>> getFarmacosOfCategory(String categoryId) async {
    final category = categories[categoryId]!;
    if (category.foods?.isEmpty ?? true) {
      category.foods =
          await getFarmacosByCategory(categoryId, offset: 0, inEvidenza: true);
    }
    otherCategories.clear();
    for (String element in category.otherCategories!) {
      otherCategories[element] = categories[element]!;
    }
    return categories[categoryId]!.foods!;
  }
}