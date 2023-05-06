import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/providers/products_provider.dart';

import '../models/extra.dart';

final currentAdditionsNotifier =
    StateNotifierProvider<CurrentAdditionsNotifier, Map<int, Map<Extra, int>>>(
        (ref) {
  return CurrentAdditionsNotifier(ref);
});

class CurrentAdditionsNotifier
    extends StateNotifier<Map<int, Map<Extra, int>>> {
  final Ref ref;

  CurrentAdditionsNotifier(this.ref) : super({});

  //init sizes for prodducts with the first size
  void initSizes(int quantity) {
    final product = ref.read(currentProductProvider);

    if (product != null) {
      if (product.sizes.isNotEmpty) {
        for (int i = 0; i < quantity; i++) {
          state = {
            ...state,
            i: {...state[i] ?? {}, product.sizes[0]: 1}
          };
        }
        state.forEach((key, value) {
          print(
              '$key: ${value.map((key, value) => MapEntry(key.name, value))}');
        });
      }
    }
  }

  // init colors for products with the first color
  void initColors(int quantity) {
    final product = ref.read(currentProductProvider);

    if (product != null) {
      if (product.colors.isNotEmpty) {
        for (int i = 0; i < quantity; i++) {
          state = {
            ...state,
            i: {...state[i] ?? {}, product.colors[0]: 1}
          };
        }
        state.forEach((key, value) {
          print(
              '$key: ${value.map((key, value) => MapEntry(key.name, value))}');
        });
      }
    }
  }

  // init mixtures for foods
  void initMixtures(int quantity) {
    final product = ref.read(currentProductProvider);
    if (product != null) {
      if (product.mixtures.isNotEmpty) {
        for (int i = 0; i < quantity; i++) {
          state = {
            ...state,
            i: {...state[i] ?? {}, product.mixtures[0]: 1}
          };
        }
      }
      state.forEach((key, value) {
        print('$key: ${value.map((key, value) => MapEntry(key.name, value))}');
      });
    }
  }

  void add(int key, Extra extra) {
    int? keyIndex = isExtraContained(key, extra);
    final extraGroupId = extra.extraGroupId;

    if (keyIndex != null) {
      print('Extra presente in key: $key - Gruppo extra: $extraGroupId');
      // increment quantity of the extra at keyIndex
      state[key]![extra] = state[key]![extra]! + 1;
      state.forEach((key, value) {
        print('$key: ${value.map((key, value) => MapEntry(key.name, value))}');
      });
    } else {
      // add extra to the map at key
      state = {
        ...state,
        key: {...state[key] ?? {}, extra: 1}
      };

      state.forEach((key, value) {
        print('$key: ${value.map((key, value) => MapEntry(key.name, value))}');
      });
    }
  }

  void remove(int key, Extra extra) {
    int? keyIndex = isExtraContained(key, extra);
    final extraGroupId = extra.extraGroupId;

    if (keyIndex != null) {
      print('Extra presente in key: $key - Gruppo extra: $extraGroupId');
      // decrement quantity of the extra at keyIndex
      state[key]![extra] = state[key]![extra]! - 1;
      if (state[key]![extra] == 0) {
        state[key]!.remove(extra);
      }
      state.forEach((key, value) {
        print('$key: ${value.map((key, value) => MapEntry(key.name, value))}');
      });
    } else {
      print('Extra non presente in key: $key - Gruppo extra: $extraGroupId');
    }
  }

  // update data of the extra at keyIndex
  void update(int key, Extra extra) {
    final extraGroupId = extra.extraGroupId;

    state[key]!.removeWhere((key, value) => key.extraGroupId == extraGroupId);
    state = {
      ...state,
      key: {...state[key] ?? {}, extra: 1}
    };

    state.forEach((key, value) {
      print('$key: ${value.map((key, value) => MapEntry(key.name, value))}');
    });
  }

  int? isExtraContained(int key, Extra extra) {
    int? containedIn;
    if (state.containsKey(key)) {
      if (state[key]!.keys.contains(extra)) {
        // element is contained in the list with the key `key` in the map
        containedIn = key;
      }
    }
    return containedIn;
  }

  double getCurrentTotal(int key) {
    double total = 0;
    state[key]?.keys.forEach((element) {
      total += element.price! * state[key]![element]!;
    });
    // print(total);
    return total;
  }

  double getTotal() {
    double total = 0;
    state.forEach((key, value) {
      total += getCurrentTotal(key);
    });
    return total;
  }

  //return all the extra of the current product at key
  List<Extra> getExtrasOf(int key) {
    List<Extra> extras = [];
    state[key]?.keys.forEach((element) {
      extras.add(element);
    });
    return extras;
  }

  bool hasNoBaseExtra(int key, Farmaco product) {
    return !state[key]!.keys.contains(product.mixtures[0]) ||
        state[key]!.keys.length > 1;
  }

  /// Return all the select extras for products
  List<Extra> getExtras() {
    List<Extra> extras = [];
    state.forEach((_, value) {
      for (var element in value.keys) {
        extras.add(element);
      }
    });
    return extras;
  }

  void clear() {
    state.clear();
  }

  @override
  void dispose() {
    print('CurrentAdditionsNotifier disposed');
    super.dispose();
  }
}


// rimuove correttamente gli extra del gruppo extra selezionato
// state[keyIndex]!.removeWhere((key, value) => key.extraGroupId == extraGroupId);
