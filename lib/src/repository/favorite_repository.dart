import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_app/src/models/farmaco.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/food_favorite.dart';
import '../models/shop.dart';
import '../models/shop_favorite.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

Future<Stream<FarmacoFavorite?>> isFavoriteFarmaco(String foodId) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}food_favorites/exist?${_apiToken}food_id=$foodId&user_id=${_user.id}';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    print(url);
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getObjectData(data as Map<String, dynamic>))
        .map((data) => FarmacoFavorite.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new FarmacoFavorite.fromJSON({}));
  }
}

Future<List<FarmacoFavorite>> getFarmacoFavorites() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return [];
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}food_favorites?${_apiToken}with=food&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  print(url);
  final streamedRest = await client.get(Uri.parse(url));
  final data = jsonDecode(streamedRest.body)['data'];
  try {
    return (data as List)
        .map((data) => FarmacoFavorite.fromJSON(data))
        .toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
}

Future<FarmacoFavorite?> addFarmacoFavorite(Farmaco farmaco) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  FarmacoFavorite favorite = FarmacoFavorite()..food = farmaco;
  favorite.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}food_favorites?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(favorite.toMap()),
    );
    print(url);
    print(json.encode(favorite.toMap()));
    return FarmacoFavorite.fromJSONAndFavorite(
        json.decode(response.body)['data'], favorite);
  } catch (e, stack) {
    print(e);
    print(stack);
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}

Future<bool> removeFarmacoFavorite(FarmacoFavorite favorite) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}food_favorites/${favorite.id}?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return json.decode(response.body)['success'];
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return false;
  }
}

Future<Stream<ShopFavorite?>> isFavoriteShop(String shopId) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}shop_favorites/exist?${_apiToken}shop_id=$shopId&user_id=${_user.id}';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    print(url);
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getObjectData(data as Map<String, dynamic>))
        .map((data) => ShopFavorite.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new ShopFavorite.fromJSON({}));
  }
}

Future<List<ShopFavorite>> getShopFavorites() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return [];
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}shop_favorites?${_apiToken}with=restaurant&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  print(url);

  final streamedRest = await client.get(Uri.parse(url));
  final data = jsonDecode(streamedRest.body)['data'];
  try {
    return (data as List).map((data) => ShopFavorite.fromJSON(data)).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
}

Future<ShopFavorite?> addShopFavorite(Shop restaurant) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  ShopFavorite favorite = ShopFavorite()..restaurant = restaurant;
  favorite.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}shop_favorites?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(favorite.toMap()),
    );
    print(url);
    print(json.encode(favorite.toMap()));
    return ShopFavorite.fromJSONAndFavorite(
        json.decode(response.body)['data'], favorite);
  } catch (e, stack) {
    print(e);
    print(stack);
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}

Future<bool> removeShopFavorite(ShopFavorite favorite) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}shop_favorites/${favorite.id}?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return json.decode(response.body)['success'];
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return false;
  }
}
