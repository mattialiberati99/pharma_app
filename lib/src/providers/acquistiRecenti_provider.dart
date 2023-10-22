import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharma_app/src/models/food_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farmaco.dart';
import '../models/order.dart';

final acquistiRecenti = FutureProvider<AcquistiRecentiProvider>((ref) async {
  return AcquistiRecentiProvider();
});

class AcquistiRecentiProvider with ChangeNotifier {
  List<Farmaco> acquistiRecenti = [];

  AcquistiRecentiProvider() {
    Future.delayed(Duration.zero, () async {
      acquistiRecenti = await loadAcquistiRecenti();
      notifyListeners();
    });
  }

  void saveAcquistiRecenti(Farmaco farmaco) async {
    acquistiRecenti.add(farmaco);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final acquistiRecentitJson =
        acquistiRecenti.map((farmaco) => farmaco.toJson()).toList();
    final acquistiRecentiJsonString = json.encode(acquistiRecentitJson);
    await prefs.setString('acquistiRecenti', acquistiRecentiJsonString);
    notifyListeners();
  }

  void saveListaAcquistiRecenti(List<Order> acquisti) async {
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
  }

  Future<List<Farmaco>> loadAcquistiRecenti() async {
    List<Farmaco> myList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listaJson = prefs.getStringList('acquistiRecenti');

    if (listaJson != null) {
      for (var el in listaJson) {
        Farmaco farmaco;
        Map<String, dynamic> decodedJson = jsonDecode(el);
        farmaco = Farmaco.fromJson(decodedJson);
        myList.add(farmaco);
      }
      notifyListeners();
    }
    return myList;
  }

  int get length {
    return acquistiRecenti.length;
  }
}
