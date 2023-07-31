import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/medicine/widgets/medicina_terapia.dart';

final terapiaProvider = ChangeNotifierProvider<TerapiaProvider>((ref) {
  return TerapiaProvider();
});

class TerapiaProvider with ChangeNotifier {
  List<MedicinaTerapia> _terapie = [];

  TerapiaProvider() {
    Future.delayed(Duration.zero, () async {
      _terapie = await loadMedicinaTerapia();
      notifyListeners();
    });
  }

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

  void add(MedicinaTerapia medicina) async {
    _terapie.add(medicina);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedData = _terapie.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('miaTerapia', encodedData);
    notifyListeners();
  }

  void remove(MedicinaTerapia medicina) async {
    _terapie.remove(medicina);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('miaTerapia');
    notifyListeners();
  }

  void removeWithId(String id) {
    for (var medicina in _terapie) {
      if (medicina.farmaco.id == (id)) {
        remove(medicina);
      }
    }
    notifyListeners();
  }

  List<MedicinaTerapia> get terapie {
    return [..._terapie];
  }

  Future<List<MedicinaTerapia>> loadMedicinaTerapia() async {
    List<MedicinaTerapia> myList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listaJson = prefs.getStringList('miaTerapia');

    if (listaJson != null) {
      for (var el in listaJson) {
        MedicinaTerapia farmaco;
        Map<String, dynamic> decodedJson = jsonDecode(el);
        farmaco = MedicinaTerapia.fromJson(decodedJson);
        myList.add(farmaco);
      }
      notifyListeners();
    }
    return myList;
  }
}
