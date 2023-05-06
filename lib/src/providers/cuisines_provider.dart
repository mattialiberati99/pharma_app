import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/models/cuisine.dart';
import 'package:pharma_app/src/repository/cuisine_repository.dart'
    as cuisineRepo;
import 'package:pharma_app/src/repository/restaurant_repository.dart';

import '../repository/cuisine_repository.dart';
import 'home_cuisines_provider.dart';

// final macroCategoriesProvider = FutureProvider((ref) {
//   final streamCuisines = getCuisines();
//   return streamCuisines;
// });

final macroCategoriesProvider = ChangeNotifierProvider<CuisinesProvider>((ref) {
  return CuisinesProvider();
});

class CuisinesProvider with ChangeNotifier {
  Map<String, Cuisine> cuisines = {};
  Map<String, Cuisine> otherCuisines = {};

  CuisinesProvider() {
    Future.delayed(Duration.zero, () async {
      addAll(await cuisineRepo.getCuisinesList());
      if (otherCuisines.isEmpty) {
        otherCuisines.addAll(cuisines);
      }
    });
  }

  add(Cuisine cuisine) {
    try {
      cuisines[cuisine.id] != null;
    } catch (e) {
      cuisines[cuisine.id!] = cuisine;
    }
    notifyListeners();
  }

  addAll(List<Cuisine> cuisines) {
    this.cuisines.addEntries(cuisines.map((e) => MapEntry(e.id!, e)));
    notifyListeners();
  }

  del(Cuisine cuisine) {
    cuisines.remove(cuisine.id);
    notifyListeners();
  }

  clear() {
    cuisines.clear();
    notifyListeners();
  }
}
