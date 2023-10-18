import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/medicine/widgets/medicina_routine.dart';

final routineProvider = ChangeNotifierProvider<RoutineProvider>((ref) {
  return RoutineProvider();
});

class RoutineProvider with ChangeNotifier {
  List<MedicinaRoutine> _routine = [];

  RoutineProvider() {
    Future.delayed(Duration.zero, () async {
      _routine = await loadMedicinaRoutine();
      notifyListeners();
    });
  }

  bool isEmpty() {
    return _routine.isEmpty;
  }

  int get length {
    return _routine.length;
  }

  bool exist(MedicinaRoutine medicina) {
    for (var medicinaInTer in _routine) {
      if (medicinaInTer.farmaco.id == medicina.farmaco.id) return true;
    }
    return false;
  }

  void add(MedicinaRoutine medicina) async {
    _routine.add(medicina);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedData = _routine.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('miaRoutine', encodedData);
    notifyListeners();
  }

  void remove(MedicinaRoutine medicina) async {
    _routine.remove(medicina);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('miaRoutine');
    notifyListeners();
  }

  void removeWithId(String id) {
    for (var medicina in _routine) {
      if (medicina.farmaco.id == (id)) {
        remove(medicina);
      }
    }
    notifyListeners();
  }

  List<MedicinaRoutine> get routine {
    return [..._routine];
  }

  Future<List<MedicinaRoutine>> loadMedicinaRoutine() async {
    List<MedicinaRoutine> myList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listaJson = prefs.getStringList('miaRoutine');

    if (listaJson != null) {
      for (var el in listaJson) {
        MedicinaRoutine farmaco;
        Map<String, dynamic> decodedJson = jsonDecode(el);
        farmaco = MedicinaRoutine.fromJson(decodedJson);
        myList.add(farmaco);
      }
      notifyListeners();
    }
    return myList;
  }
}
