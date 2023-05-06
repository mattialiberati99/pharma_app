
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/extra.dart';
import '../repository/settings_repository.dart';

final filterProvider = ChangeNotifierProvider<FilterProvider>((ref) {
  return FilterProvider();
});

class FilterProvider with ChangeNotifier {
  Map<Extra, bool> types = {};


  RangeValues values = const RangeValues(0, 5000);
  RangeLabels labels = RangeLabels(0.toString(), 5000.toString());

  FilterProvider() {
    loadTypes();
  }

  Future<void> loadTypes() async {
    types = { for (var v in await getTypes()) v : false };
    if (kDebugMode) {
      print("TIPI: ${types.length}");
    }
    notifyListeners();
  }

  Map<String, dynamic> toQuery() {
    var extras=[];
    types.forEach((key, value) {if(value){
      extras.add(key.id);
    }
    });
    return {
      "extras[]":extras,
      "prezzo_max":values.end.toString(),
      "prezzo_min":values.start.toString(),
    };
  }
}
