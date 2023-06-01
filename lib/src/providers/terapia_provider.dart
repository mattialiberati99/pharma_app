import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/medicine/widgets/medicineTerapia.dart';

final terapiaProvider = ChangeNotifierProvider<TerapiaProvider>((ref) {
  return TerapiaProvider();
});

class TerapiaProvider with ChangeNotifier {
  List<MedicinaTerapia> _terapie = [];

  bool isEmpty() {
    return _terapie.isEmpty;
  }

  int get length {
    return _terapie.length;
  }

  bool exist(MedicinaTerapia medicina) {
    for (var medicinaInTer in _terapie) {
      if (medicinaInTer.farmaco.id == medicina.farmaco.id) return true;
    }
    return false;
  }

  void add(MedicinaTerapia medicina) {
    _terapie.add(medicina);
    notifyListeners();
  }

  void remove(MedicinaTerapia medicina) {
    _terapie.remove(medicina);
    notifyListeners();
  }

  void removeWithId(String id) {
    for (var medicina in _terapie) {
      if (medicina.farmaco.id == (id)) {
        remove(medicina);
      }
    }
  }

  List<MedicinaTerapia> get terapie {
    return [..._terapie];
  }
}
