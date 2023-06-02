// create a riverpod provider handles a bool value

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/providers/shops_provider.dart';

import 'cart_provider.dart';

/// Check if cart contains a product of the current shop
final canAddProvider = Provider((ref) {
  final shopId = ref.watch(currentFarmacieShopIDProvider);
  print(shopId.toString());
  final cart = ref.watch(cartProvider);
  print(cart.carts.toString());
  // check if there are products of other restaurants  in the cart
  if (cart.carts.isEmpty) {
    return true;
  }
  if (cart.carts.isNotEmpty) {
    return cart.carts
        .every((element) => element.product!.farmacia?.id == shopId);
  }
  return true;
});
