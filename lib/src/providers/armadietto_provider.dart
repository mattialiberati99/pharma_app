import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/medicine/widgets/medicina_armadietto.dart';

final armadiettoProvider = ChangeNotifierProvider<ArmadiettoProvider>((ref) {
  return ArmadiettoProvider();
});

class ArmadiettoProvider with ChangeNotifier {
  List<MedicinaArmadietto> _armadietto = [];

  bool isEmpty() {
    return _armadietto.isEmpty;
  }

  int get length {
    return _armadietto.length;
  }

  bool exist(MedicinaArmadietto medicina) {
    for (var medicinaInArmadio in _armadietto) {
      if (medicinaInArmadio.farmaco.id == medicina.farmaco.id) return true;
    }
    return false;
  }

  void add(MedicinaArmadietto medicina) {
    _armadietto.add(medicina);
    notifyListeners();
  }

  void remove(MedicinaArmadietto medicina) {
    _armadietto.remove(medicina);
    notifyListeners();
  }

  void removeWithId(String id) {
    for (var medicina in _armadietto) {
      if (medicina.farmaco.id == (id)) {
        remove(medicina);
      }
    }
  }

  List<MedicinaArmadietto> get armadietto {
    return [..._armadietto];
  }
}
