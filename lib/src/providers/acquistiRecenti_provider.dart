import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharma_app/src/models/food_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../models/farmaco.dart';
import '../models/order.dart';

final acquistiRecentiProvider =
    ChangeNotifierProvider<AcquistiRecentiProvider>((ref) {
  return AcquistiRecentiProvider();
});

class AcquistiRecentiProvider with ChangeNotifier {
  List<Farmaco> acquistiRecenti = [];

  AcquistiRecentiProvider() {
    /*  Future.delayed(Duration.zero, () async {
      acquistiRecenti = await loadAcquistiRecenti();
      notifyListeners();
    }); */
  }

  Future<void> loadData() async {
    acquistiRecenti = await loadAcquistiRecenti();
    notifyListeners();
  }

  void saveAcquistiRecenti(Farmaco farmaco) async {
    if (!acquistiRecenti.contains(farmaco)) {
      acquistiRecenti.add(farmaco);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final acquistiRecentiJson =
          acquistiRecenti.map((farmaco) => farmaco.toJson()).toList();
      final acquistiRecentiJsonString =
          acquistiRecentiJson.map((json) => jsonEncode(json)).toList();

      await prefs.setStringList(
          'mieiAcquistiRecenti', acquistiRecentiJsonString);
      notifyListeners();
    }
  }

/*   void saveListaAcquistiRecenti(List<Order> acquisti) async {
    for (Order a in acquisti) {
      for (FarmacoOrder f in a.foodOrders) {
        acquistiRecenti.add(f.product!);
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final acquistiRecentitJson =
        acquistiRecenti.map((farmaco) => farmaco.toJson()).toList();
    final acquistiRecentiJsonString = json.encode(acquistiRecentitJson);
    await prefs.setString('acquistiRecenti', acquistiRecentiJsonString);
    notifyListeners();
  } */

  Future<List<Farmaco>> loadAcquistiRecenti() async {
    List<Farmaco> myList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final listaJson = prefs.getStringList('mieiAcquistiRecenti');

    try {
      if (listaJson != null) {
        final acquistiRecentiJson =
            listaJson.map((json) => jsonDecode(json)).toList();
        final mieiAcquistiRecenti =
            acquistiRecentiJson.map((json) => Farmaco.fromJson(json)).toList();
        acquistiRecenti = mieiAcquistiRecenti;
        notifyListeners();
        return acquistiRecenti;
        logger.info('PRESI CORRETTAMENTE');
      } else {
        return [];
      }
    } catch (error) {
      logger.error('ERRORE ACQUISTI RECENTI: $error');
    }
    return myList;
  }

  int get length {
    return acquistiRecenti.length;
  }
}
