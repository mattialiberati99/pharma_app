import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/credit_card.dart';

List<CreditCard> cards = <CreditCard>[];
//indice per la creazione di nuove carte in memoria
int index = 0;

Future<bool> getUserCreditCards() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = await prefs.getString("credit_card");
    var responseJson = json.decode(string!);
    cards = (responseJson as List).map((p) => CreditCard.fromJSON(p)).toList();
    if (cards.isNotEmpty) {
      //ultima carta installata +1
      index = cards[cards.length - 1].id! + 1;
    }
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> addCreditCard(CreditCard creditCard) async {
  try {
    if (creditCard.id == null || creditCard.id! <= 0) {
      creditCard.id = index++;
    }
    cards.add(creditCard);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString('credit_card', json.encode(cards));

    return result;
  } catch (ex) {
    print(ex);
    return false;
  }
}

Future<bool> updateCreditCard(CreditCard card) async {
  cards.removeWhere((element) => element.id == card.id);
  cards.add(card);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString('credit_card', json.encode(cards));
  return result;
}

Future<bool> removeCreditCard(CreditCard card) async {
  cards.removeWhere((element) => element.id == card.id);
  //cards.add(card);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString('credit_card', json.encode(cards));
  return result;
}
