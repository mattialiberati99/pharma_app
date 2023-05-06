import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:global_configuration/global_configuration.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/user.dart';
import '../providers/settings_provider.dart';
import '../providers/user_provider.dart';

Future<List<Address>> getAddresses() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=is_default&sortedBy=desc';
  try {
    final client = new http.Client();
    print(url);
    final streamedRest = await client.get(Uri.parse(url));
    final data=jsonDecode(streamedRest.body)['data'];
    return (data as List)
        .map((data) {
      return Address.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return [];
  }
}

Future<Address> getDefaultAddress() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=is_default&sortedBy=desc';
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
    var responseJson = json.decode(response.body);
    return (responseJson["data"] as List)
        .map((p) => Address.fromJSON(p))
        .first; // ?? new Address.fromJSON({});
    /*var list=streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data as Map<String, dynamic>)).expand((data) => (data as List)).map((data) {
      var address= Address.fromJSON(data);
      return address;
    });
    if(await list.isEmpty){return new Address.fromJSON({});}else{
      return list.first;
    }*/

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> addAddress(Address address) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    print(url);
    print(json.encode(address.toMap()));
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e, stack) {
    print(e);
    print(stack);
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> updateAddress(Address address) async {
  User _user = currentUser.value;
  // print(address);
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();

  try {
    final response = await client.put(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<bool> removeDeliveryAddress(Address address) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return json.decode(response.body)['success'];
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return false;
  }
}

Future<String?> searchAddress({required String address}) async {
  String API = setting.value.googleMapsKey!;
  String _add = address.replaceAll(" ", "+");
  String randomToken = randomNumeric(10);
  String url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${_add}&origin=${Address.defaultLatitude},${Address.defaultLongitude}&components=country:it&type=address&language=it&key=${API}&sessiontoken=${randomToken}';
  var resp = await http.get(Uri.parse(url));

  // TODO You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable
  print("searchAddress ::: $url");
  print("searchAddress ::: ${resp.body}");

  List? predictions = json.decode(resp.body)['predictions'];
  if (predictions != null && predictions.isNotEmpty) {
    return json.decode(resp.body)['predictions'][0]['description'];
  } else {
    return null;
  }
}

Future<String?> searchCity({required String address}) async {
  String API = setting.value.googleMapsKey!;
  String _add = address.replaceAll(" ", "+");
  String randomToken = randomNumeric(10);
  String url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${_add}&origin=${Address.defaultLatitude},${Address.defaultLongitude}&components=country:it&type=(cities)&language=it&key=${API}&sessiontoken=${randomToken}';
  var resp = await http.get(Uri.parse(url));
  //print(url);
  //print(resp.body);
  List? predictions = json.decode(resp.body)['predictions'];
  if (predictions != null && predictions.isNotEmpty) {
    return json.decode(resp.body)['predictions'][0]['description'];
  } else {
    return null;
  }
}
