import 'package:flutter/material.dart';

import '../helpers/custom_trace.dart';

class Setting {
  String? appName = '';
  String? defaultCurrency;
  bool currencyRight = true;
  int currencyDecimalDigits = 2;
  bool payPalEnabled = true;
  bool stripeEnabled = true;
  String? stripeKey;
  String? googleMapsKey;

  String? privacyUrl;
  String? termsUrl;
  int? minVersion;
  bool maintenance = false;
  String mailSupport = "";
  String phoneSupport = "";
  bool verifyEmail = false;

  ValueNotifier<Brightness> brightness = new ValueNotifier(Brightness.light);

  static const int minuteFascia = 30;

  Setting();

  Setting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      appName = jsonMap['app_name'] ?? null;
      googleMapsKey = jsonMap['google_maps_key'] ?? null;
      defaultCurrency = jsonMap['default_currency'] ?? '';
      currencyDecimalDigits =
          int.tryParse(jsonMap['default_currency_decimal_digits'] ?? '2') ?? 2;
      currencyRight =
          jsonMap['currency_right'] == null || jsonMap['currency_right'] == '0'
              ? false
              : true;
      payPalEnabled =
          jsonMap['enable_paypal'] == null || jsonMap['enable_paypal'] == '0'
              ? false
              : true;
      stripeEnabled =
          jsonMap['enable_stripe'] == null || jsonMap['enable_stripe'] == '0'
              ? false
              : true;

      privacyUrl = jsonMap['privacy_url'];
      termsUrl = jsonMap['terms_url'];
      stripeKey = jsonMap['stripe_key'];
      minVersion = int.parse(jsonMap['min_version'].toString());
      maintenance =
          jsonMap['maintenance'] == null || jsonMap['maintenance'] == '0'
              ? false
              : true;
      mailSupport = jsonMap['mail_support'];
      phoneSupport = jsonMap['phone_support'];
      verifyEmail = jsonMap['require_validation'] == null ||
              jsonMap['require_validation'] == '0'
          ? false
          : true;
    } catch (e, stack) {
      print(stack);
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["app_name"] = appName;
    map["default_currency"] = defaultCurrency;
    map["default_currency_decimal_digits"] = currencyDecimalDigits;
    map["currency_right"] = currencyRight;
    map["enable_paypal"] = payPalEnabled;
    map["enable_stripe"] = stripeEnabled;
    return map;
  }
}
