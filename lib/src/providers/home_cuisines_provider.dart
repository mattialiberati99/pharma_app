import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/pages/home/widgets/home_cuisine_filter.dart';
import 'package:pharma_app/src/repository/category_repository.dart';

import '../models/cuisine.dart';
import '../repository/cuisine_repository.dart';
import 'cuisines_provider.dart';

///Provider for Cuisine selected on Pre Home
StateProvider<String> currentCuisineProvider = StateProvider((ref) => '0');

///Provider for Home Shops filtering
///in [HomeCuisineFilter] in [onCuisineSelected]
final homeSelectedCuisineProvider = StateProvider((ref) => '');

///Provider for Cuisines in Pre Home
final preHomeCuisinesProvider = FutureProvider((ref) async {
  final macroCategories = ref.watch(macroCategoriesProvider);
  return macroCategories.cuisines.values
      .where((cuisine) => cuisine.parentId == 'null')
      .toList();
});

///Provider for Cuisines in Home filter widget
final homeSubCuisinesProvider = FutureProvider((ref) async {
  final homeSubCuisines = <Cuisine>[];
  final selectedCuisineId = ref.watch(currentCuisineProvider);
  await getSubCuisines(selectedCuisineId)
      .then((value) => value.forEach((element) {
            homeSubCuisines.add(element);
          }));
  final allSubCuisine = await getCuisinesList().then((cuisines) =>
      cuisines.firstWhere((cuisine) => cuisine.id == selectedCuisineId));
  return [allSubCuisine, ...homeSubCuisines];
});

final currentCuisineFromID =
    Provider.autoDispose.family<Cuisine, String>((ref, cuisineId) {
  final cuisines = ref.watch(macroCategoriesProvider);
  final currentCuisine =
      cuisines.cuisines.values.firstWhere((c) => c.id == cuisineId);
  return currentCuisine;
});
