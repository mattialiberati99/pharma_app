import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/medicine/widgets/medicina_terapia.dart';

final indirizziConsegnaProvider =
    ChangeNotifierProvider<IndirizziConsegnaProvider>((ref) {
  return IndirizziConsegnaProvider();
});

class IndirizziConsegnaProvider with ChangeNotifier {
  Map<String, List<String>> indirizzi = {};
  late List<bool> selected;

  IndirizziConsegnaProvider() {
    Future.delayed(Duration.zero, () async {
      loadIndirizzi();
      selected.length = indirizzi.length;
      for (int i = 0; i < selected.length; i++) {
        selected[i] = false;
      }
      notifyListeners();
    });
  }

  bool isEmpty() {
    return indirizzi.isEmpty;
  }

  bool exist(String nome) {
    return indirizzi.containsKey(nome);
  }

  void add(String nome, String ind, String num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> indirizzi = {};

    // Leggi la mappa attuale dalle SharedPreferences (se esiste)
    String? savedIndirizzi = prefs.getString('indirizzi');
    if (savedIndirizzi != null) {
      indirizzi = jsonDecode(savedIndirizzi);
    }

    if (indirizzi.containsKey(nome)) {
      // La chiave esiste già nella mappa
      Fluttertoast.showToast(
          msg: 'Esiste già un indirizzo con questo nome.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      indirizzi[nome] = ['$ind, $num'];
      // Salva la mappa nelle SharedPreferences
      await prefs.setString('mieiIndirizzi', jsonEncode(indirizzi));
    }
    notifyListeners();
  }

  Future<void> loadIndirizzi() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('indirizzi');

    if (jsonString != null) {
      final savedMap = json.decode(jsonString);
      if (savedMap is Map<String, dynamic>) {
        // Check if the loaded data is a Map
        final Map<String, List<String>> loadedMap = {};
        savedMap.forEach((key, value) {
          if (value is List<String>) {
            loadedMap[key] = value;
          }
        });
        indirizzi = loadedMap;
      }
    }
  }

/*   Future<Map<String, List<String>>> loadIndirizzi() async {
    Map<String, List<String>> indirizzi = {};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedIndirizzi = prefs.getString('mieiIndirizzi');

    if (savedIndirizzi != null) {
      Map<String, List<String>> indirizzi = jsonDecode(savedIndirizzi);
     
      notifyListeners();
    }
    return indirizzi;
  }

  void remove(MedicinaTerapia medicina) async {
    _terapie.remove(medicina);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('miaTerapia');
    notifyListeners();
  } */
}
