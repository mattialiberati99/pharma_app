import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/farmaco.dart';
import '../repository/food_repository.dart' as foodRepo;
import '../repository/food_repository.dart';

final foodProvider = ChangeNotifierProvider.autoDispose
    .family<FarmacoProvider, String>((ref, id) {
  return FarmacoProvider(id);
});

class FarmacoProvider with ChangeNotifier {
  Map<String, Farmaco> foods = {};
  String restaurantId;

  FarmacoProvider(this.restaurantId) {
    foods.clear();
    Future.delayed(Duration.zero, () async {
      addAll(await foodRepo.getFeaturedFarmacosOfRestaurant(restaurantId));
    });
  }

  add(Farmaco farmaco) {
    try {
      foods[farmaco.id] != null;
    } catch (e) {
      foods[farmaco.id!] = farmaco;
    }
    notifyListeners();
  }

  addAll(List<Farmaco> foods) {
    this.foods.addEntries(foods.map((e) => MapEntry(e.id!, e)));
    notifyListeners();
  }

  del(Farmaco food) {
    foods.remove(food.id);
    notifyListeners();
  }

  clear() {
    foods.clear();
    notifyListeners();
  }

  getFarmaco(id) async {
    Farmaco? food;
    try {
      food = foods[id]!;
    } catch (e) {
      food = await foodRepo.getFarmaco(id);
      if (food != null) {
        foods[food.id!] = food;
      }
    }
    return food;
  }

  getFarmacosOfCategory(String categoryId) async {
    foods.clear();
    addAll(
        await getFarmacosByCategory(categoryId, offset: 0, inEvidenza: true));
    notifyListeners();
  }
}
