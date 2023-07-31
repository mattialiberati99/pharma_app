import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/medicine/widgets/medicina_armadietto.dart';

final armadiettoProvider = ChangeNotifierProvider<ArmadiettoProvider>((ref) {
  return ArmadiettoProvider();
});

class ArmadiettoProvider with ChangeNotifier {
  List<MedicinaArmadietto> _armadietto = [];

  ArmadiettoProvider() {
    Future.delayed(Duration.zero, () async {
      _armadietto = await loadMedicinaArmadietto();
      notifyListeners();
    });
  }

  bool isEmpty() {
    return _armadietto.isEmpty;
  }

  int get length {
    return _armadietto.length;
  }

  //List<MedicinaArmadietto> get armadietto => _armadietto;

  bool exist(MedicinaArmadietto medicina) {
    for (var medicinaInArmadio in _armadietto) {
      if (medicinaInArmadio.farmaco.id == medicina.farmaco.id) return true;
    }
    return false;
  }

  void aggiungi(MedicinaArmadietto medicina) async {
    _armadietto.add(medicina);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedData = _armadietto.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('mioArmadietto', encodedData);
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

  Future<List<MedicinaArmadietto>> loadMedicinaArmadietto() async {
    List<MedicinaArmadietto> myList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listaJson = prefs.getStringList('mioArmadietto');

    if (listaJson != null) {
      for (var el in listaJson) {
        MedicinaArmadietto farmaco;
        Map<String, dynamic> decodedJson = jsonDecode(el);
        farmaco = MedicinaArmadietto.fromJson(decodedJson);
        myList.add(farmaco);
      }
      notifyListeners();
    }
    return myList;
  }
}
