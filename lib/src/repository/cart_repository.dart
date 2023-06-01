import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

Future<List<Cart>> getCart() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return [];
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts?${_apiToken}with=food;food.restaurant;extras;food.extras.extraGroup;food.extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  print(Uri.parse(url));
  final streamedRest = await client.get(Uri.parse(url));
  final data = jsonDecode(streamedRest.body)['data'];
  return (data as List).map((data) {
    return Cart.fromJSON(data);
  }).toList();
}

Future<Cart> addCart(Cart cart, bool reset) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  Map<String, dynamic> decodedJSON = {};
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String _resetParam = 'reset=${reset ? 1 : 0}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts?$_apiToken&$_resetParam&with=food;food.restaurant;extras;food.extras.extraGroup;food.extras';
  final client = new http.Client();
  print(Uri.parse(url));
  print(json.encode(cart.toMap()));
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(CustomTrace(StackTrace.current, message: e.toString()));
  }
  return Cart.fromJSON(decodedJSON);
}

Future<Cart> updateCart(Cart cart) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/update/${cart.id}?$_apiToken';
  final client = new http.Client();

  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  print(url);
  return Cart.fromJSON(json.decode(response.body)['data']);
}

Future<bool> removeCart(Cart cart) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Helper.getBoolData(json.decode(response.body));
}
