import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final researchProvider = ChangeNotifierProvider<ResearchProvider>((ref) {
  return ResearchProvider();
});

class ResearchProvider with ChangeNotifier {
  List<String> researchItems = [];

  ResearchProvider() {
    Future.delayed(Duration.zero, () async {
      researchItems = await loadResearchItems();
      notifyListeners();
    });
  }

  loadResearchItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? researchItemList = prefs.getStringList('researchItems');

    if (researchItemList != null) {
      researchItems = researchItemList;
      notifyListeners();
    }
  }

  saveResearchItems(String itemName) async {
    researchItems.add(itemName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('researchItems', researchItems);
    notifyListeners();
  }

  elimina() {
    researchItems.clear();
    notifyListeners();
  }
}
