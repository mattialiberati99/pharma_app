import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/shop_card.dart';
import 'package:pharma_app/src/components/shop_card_horizontal.dart';
import 'package:pharma_app/src/models/address.dart';
import 'package:pharma_app/src/pages/home/widgets/home_cuisine_filter.dart';
import 'package:pharma_app/src/providers/position_provider.dart';
import 'package:pharma_app/src/repository/restaurant_repository.dart';
import 'package:pharma_app/src/repository/settings_repository.dart';

import '../models/shop.dart';
import '../repository/favorite_repository.dart';

///Provider for current Shop Detail page used in [shopItemsProvider]
///modified in [ShopCard] and [ShopCardHorizontal] onTap
final currentShopIDProvider = StateProvider<String>((ref) {
  return '';
});

final currentFarmacieShopIDProvider = StateProvider<String>((ref) {
  return '';
});

final currentShopProvider = FutureProvider((ref) async {
  final id = ref.watch(currentShopIDProvider);
  return await getRestaurant(id);
});

final favoriteShopsProvider = FutureProvider.autoDispose((ref) async {
  return await getShopFavorites();
});

final popularShopsProvider = FutureProvider((ref) async {
  final currentAddress = await getCurrentLocation();
  return await getPopularRestaurants(currentAddress);
});

final nearestShopsProvider = FutureProvider((ref) async {
  final myLocation = ref.watch(positionProvider).getAddress();
  return await getNearRestaurants(myLocation, myLocation);
});

final nearestAddressShopsProvider = FutureProvider((ref) async {
  final address = ref.watch(suggestedAddressProvider);
  return await getNearRestaurants(address, address);
});

final recentRestaurantsProvider = FutureProvider<List<Shop>>((ref) async {
  return await loadRecentRestaurants();
});

///Provider filters shops based on suggested address in [PreHome]
final suggestedAddressProvider =
    StateProvider<Address>((ref) => ref.watch(positionProvider).getAddress());

///Provider filters shops based on available_for_delivery
///in [HomeCuisineFilter]
final deliveryFilterProvider = StateProvider.autoDispose((ref) => false);

final shopsFilteredByDeliveryProvider =
    Provider.autoDispose.family<List<Shop>, List<Shop>>((ref, shops) {
  final availableForDelivery = ref.watch(deliveryFilterProvider);
  if (shops != null) {
    var tempList = [...shops];

    final deliveryFiltered = tempList
        .where((Shop shop) => shop.availableForDelivery == availableForDelivery)
        .toList();

    return deliveryFiltered;
  }
  return [];
});

final shopsFilteredByCuisineProvider =
    FutureProvider.family<List<Shop>, String>((ref, selectedCuisine) async {
  final currentAddress = await getCurrentLocation();
  return await getRestaurantsOfCuisine(selectedCuisine,
      address: currentAddress);
});

final nearestShopsProviderWithProducts =
    FutureProvider.family<List<Shop>, String>((ref, idFarmaco) async {
  final myLocation = ref.watch(positionProvider).getAddress();
  final farmacie = await getNearRestaurants(myLocation, myLocation);
  return farmacie
      .where(
        (element) => element.id == idFarmaco,
      )
      .toList();
});
