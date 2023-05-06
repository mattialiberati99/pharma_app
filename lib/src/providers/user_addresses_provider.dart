import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';

import '../models/address.dart';
import '../repository/addresses_repository.dart';

final userAddressesProvider = FutureProvider.autoDispose<List<Address>>((ref) {
  return getAddresses();
});

final userDefaultAddressProvider = FutureProvider.autoDispose<Address>((ref) {
  return getDefaultAddress();
});

final userDefaultCartAddressProvider = Provider.autoDispose<Address?>((ref) {
  return ref.watch(cartProvider).deliveryAddress;
});
