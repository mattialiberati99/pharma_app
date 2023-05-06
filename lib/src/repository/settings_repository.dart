import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/coupon.dart';
import '../models/extra.dart';
import '../models/prezzo_consegna.dart';
import '../models/setting.dart';
import '../providers/settings_provider.dart';

ValueNotifier<Address> deliveryAddress = new ValueNotifier(new Address());

ValueNotifier<List<PrezzoConsegna>> consegna =
    new ValueNotifier(<PrezzoConsegna>[]);
Coupon coupon = new Coupon.fromJSON({});
final navigatorKey = GlobalKey<NavigatorState>();

Future<Setting> initSettings() async {
  print("initSettings");
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}settings';
  try {
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
          () => http.get(Uri.parse(url), headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      }).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    if (response.statusCode == 200 &&
        response.headers.containsValue('application/json')) {
      setting.value= Setting.fromJSON(json.decode(response.body)['data']);
      return setting.value;
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e, stack) {
    print(e);
    print(stack);
    print(CustomTrace(StackTrace.current, message: url).toString());
    return setting.value;
  }
  return setting.value;
}

Future<List<PrezzoConsegna>> initPrezziConsegna() async {
  List<PrezzoConsegna> _prezzi;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}consegna';
  try {
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
      () => http.get(Uri.parse(url), headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      }).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    if (response.statusCode == 200 &&
        response.headers.containsValue('application/json')) {
      if (json.decode(response.body)['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'prezzi_consegna', json.encode(json.decode(response.body)['data']));
        var responseJson = json.decode(response.body)['data'];
        _prezzi = (responseJson as List)
            .map((p) => PrezzoConsegna.fromJSON(p))
            .toList();

        consegna.value = _prezzi;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        consegna.notifyListeners();
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    print(e);
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
  return consegna.value;
}

Future<Address> changeCurrentLocation(Address _address) async {
  Address address = new Address()
    ..latitude = _address.latitude
    ..longitude = _address.longitude
    ..id = "1"
    ..address = "start position";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('my_address', json.encode(address.toMap()));
  deliveryAddress.value = address;
  return address;
}

Future<Address> getCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  await prefs.clear();
  if (prefs.containsKey('my_address')) {
    deliveryAddress.value =
        Address.fromJSON(json.decode(prefs.getString('my_address')!));
    return deliveryAddress.value;
  } else {
    deliveryAddress.value = Address.fromJSON({});
    return Address.fromJSON({});
  }
}

Future<dynamic> setCurrentLocation() async {
  var location = new Location();
  final whenDone = new Completer();
  Address _address = new Address();
  location.requestService().then((value) async {
    location.getLocation().then((_locationData) async {
      String _addressName = '';
      _address = Address.fromJSON({
        'address': _addressName,
        'latitude': _locationData.latitude,
        'longitude': _locationData.longitude
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('my_address', json.encode(_address.toMap()));
      whenDone.complete(_address);
    }).timeout(Duration(seconds: 10), onTimeout: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('my_address', json.encode(_address.toMap()));
      whenDone.complete(_address);
      return null;
    }).catchError((e) {
      whenDone.complete(_address);
    });
  });
  return whenDone.future;
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}

Future<void> setDefaultLanguage(String language) async {
  if (language != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = await prefs.get('language') as String;
  }
  return defaultLanguage;
}

Future<void> saveMessageId(String messageId) async {
  if (messageId != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('google.message_id', messageId);
  }
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get('google.message_id') as String;
}

void clearCoupon() {
  coupon = Coupon.fromJSON({});
}

Future<List<Extra>> getTypes() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}extras?search=extra_group_id:2&searchFields=extra_group_id:=';
  if (kDebugMode) {
    print(url);
  }
  final client = http.Client();
  final streamedRest = await client.get(Uri.parse(url));
  final jsonResp = jsonDecode(streamedRest.body)['data'];
  try {
    return (jsonResp as List).map((data) => Extra.fromJSON(data)).toList();
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: url).toString());
    }
    return [];
  }
}

Future<Address> changeCurrentAddressFromLAtLng(LatLng _latLng) async {
  Address address = Address()
    ..latitude = _latLng.latitude
    ..longitude = _latLng.longitude
    ..id = "1"
    ..address = "start position";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('my_address', json.encode(address.toMap()));
  deliveryAddress.value = address;
  debugPrint('NEW ADDRESS - ID:${address.id} - LAT:${address.latitude} LONG:${address.longitude}');
  return address;
}
