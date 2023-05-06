import 'package:flutter/material.dart';

import '../helpers/custom_trace.dart';

class Setting {
  String? appName = 'Pharma Delivery';
  double? defaultTax;
  String? defaultCurrency;
  String? distanceUnit;
  bool currencyRight = true;
  int currencyDecimalDigits = 2;
  bool payPalEnabled = true;
  bool stripeEnabled = true;
  bool razorPayEnabled = true;
  String? mainColor;
  String? mainDarkColor;
  String? secondColor;
  String? secondDarkColor;
  String? accentColor;
  String? accentDarkColor;
  String? scaffoldDarkColor;
  String? scaffoldColor;
  String? googleMapsKey;
  String? googleMapsKeyIos;
  String? fcmKey;
  ValueNotifier<Locale> mobileLanguage = new ValueNotifier(Locale('en', ''));
  String? appVersion;
  bool? enableVersion = true;
  List<String> homeSections = [];
  bool liveTracking = false;
  String? privacyUrl;
  int? minVersion = 1;
  bool maintenance = false;
  String mailSupport = "";
  String phoneSupport = "";
  bool verifyEmail = false;
  bool showMobile = false;
  bool updateAtStart = false;
  String provincie = "";
  bool showBanner = true;

  ValueNotifier<Brightness> brightness = new ValueNotifier(Brightness.light);

  Setting();

  Setting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      appName = jsonMap['app_name'];
      mainColor = jsonMap['main_color'] ?? null;
      mainDarkColor = jsonMap['main_dark_color'] ?? '';
      secondColor = jsonMap['second_color'] ?? '';
      secondDarkColor = jsonMap['second_dark_color'] ?? '';
      accentColor = jsonMap['accent_color'] ?? '';
      accentDarkColor = jsonMap['accent_dark_color'] ?? '';
      scaffoldDarkColor = jsonMap['scaffold_dark_color'] ?? '';
      scaffoldColor = jsonMap['scaffold_color'] ?? '';
      googleMapsKey = jsonMap['google_maps_key'] ?? null;
      googleMapsKeyIos = jsonMap['google_maps_api_key_ios'] ?? null;
      fcmKey = jsonMap['fcm_key'] ?? null;
      mobileLanguage.value = Locale(jsonMap['mobile_language'] ?? "en", '');
      appVersion = jsonMap['app_version'] ?? '';
      distanceUnit = jsonMap['distance_unit'] ?? 'km';
      enableVersion =
          jsonMap['enable_version'] == null || jsonMap['enable_version'] == '0'
              ? false
              : true;
      defaultTax = double.tryParse(jsonMap['default_tax'] ?? '0') ??
          0.0; //double.parse(jsonMap['default_tax'].toString());
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
      razorPayEnabled = jsonMap['enable_razorpay'] == null ||
              jsonMap['enable_razorpay'] == '0'
          ? false
          : true;
      for (int _i = 1; _i <= 12; _i++) {
        homeSections.add(jsonMap['home_section_' + _i.toString()] != null
            ? jsonMap['home_section_' + _i.toString()]
            : 'empty');
      }
      liveTracking =
          jsonMap['live_tracking'] == true || jsonMap['live_tracking'] == 1;
      privacyUrl = jsonMap['privacy_url'];
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
      showMobile =
          jsonMap['show_mobile'] == null || jsonMap['show_mobile'] == '0'
              ? false
              : true;
      print(jsonMap['update_start']);
      updateAtStart =
          jsonMap['update_start'] == null || jsonMap['update_start'] == '0'
              ? false
              : true;
      provincie = jsonMap['provincie'] ?? "";
    } catch (e, stack) {
      print(stack);
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["app_name"] = appName;
    map["default_tax"] = defaultTax;
    map["default_currency"] = defaultCurrency;
    map["default_currency_decimal_digits"] = currencyDecimalDigits;
    map["currency_right"] = currencyRight;
    map["enable_paypal"] = payPalEnabled;
    map["enable_stripe"] = stripeEnabled;
    map["enable_razorpay"] = razorPayEnabled;
    map["mobile_language"] = mobileLanguage.value.languageCode;
    return map;
  }
}
