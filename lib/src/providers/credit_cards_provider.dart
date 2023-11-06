import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/credit_card.dart';

final creditCardsProvider = FutureProvider.autoDispose((ref) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = await prefs.getString("credit_card");
    var responseJson = json.decode(string!);
    return await (responseJson as List)
        .map((p) => CreditCard.fromJSON(p))
        .toList();
  } catch (e) {
    print(e);
    return <CreditCard>[];
  }
});
