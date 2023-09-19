import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final armadiettoResearchProvider =
    ChangeNotifierProvider<ArmadiettoResearchProvider>((ref) {
  return ArmadiettoResearchProvider();
});

class ArmadiettoResearchProvider with ChangeNotifier {
  List<String> armadiettoResearchItems = [];

  ArmadiettoResearchProvider() {
    Future.delayed(Duration.zero, () async {
      armadiettoResearchItems = await loadResearchItems();
      notifyListeners();
    });
  }

  loadResearchItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? researchItemList =
        prefs.getStringList('armadiettoResearchItems');

    if (researchItemList != null) {
      armadiettoResearchItems = researchItemList;
      notifyListeners();
    }
  }

  saveResearchItems(String itemName) async {
    armadiettoResearchItems.add(itemName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'armadiettoResearchItems', armadiettoResearchItems);
    notifyListeners();
  }

  elimina() {
    armadiettoResearchItems.clear();
    notifyListeners();
  }
}
