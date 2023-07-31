import 'package:flutter_credit_card/credit_card_brand.dart';

import '../helpers/custom_trace.dart';

class CreditCard {
  int? id;
  String intestazione = '';
  String number = '';
  String? expiration;

  String cvc = '';
  bool valid = false;
  bool defaultCard = false;

  CreditCard();

  CreditCard.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      number = jsonMap['numero_carta'].toString();
      expiration = jsonMap['scadenza'].toString();
      intestazione = jsonMap['intestazione'].toString();
      cvc = jsonMap['cvc'].toString();
      valid = validated();
      defaultCard = jsonMap['default_card'] ?? false;
    } catch (e) {
      id = -1;
      number = '';
      expiration = '';
      intestazione = '';
      cvc = '';

      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["stripe_number"] = number.replaceAll(" ", "");
    var chunks = expiration!.split("/");
    map["stripe_exp_month"] = chunks[0];
    map["stripe_exp_year"] = chunks[1];
    map["intestazione"] = intestazione;
    map["stripe_cvc"] = cvc;
    map["payment_method"] = "credit_card";
    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "numero_carta": this.number,
      "scadenza": this.expiration,
      "intestazione": this.intestazione,
      "cvc": this.cvc,
      "default_card": this.defaultCard
    };
  }

  bool validated() {
    return number != null &&
        number != '' &&
        expiration != null &&
        expiration != '' &&
        cvc != null &&
        cvc != '';
  }
}
