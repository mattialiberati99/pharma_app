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
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final encodedData = _armadietto.map((e) => jsonEncode(e.toJson())).toList();
    // await prefs.setStringList('armadietto',encodedData);
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listaJson = jsonEncode(_armadietto.map((e) => e.toJson()).toList());
    await prefs.setString('medicina_armadietto', listaJson);
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

  Future<void> loadMedicinaArmadietto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? listaJson = prefs.getString('medicina_armadietto');

    if (listaJson != null) {
      List<dynamic> listaDecodificata = jsonDecode(listaJson);
      _armadietto =
          listaDecodificata.map((e) => MedicinaArmadietto.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
