import 'dart:convert';
import 'dart:io';

import 'package:pharma_app/src/models/category.dart';

import '../models/farmaco.dart';
import '../providers/filter_provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';

Future<List<Farmaco>> getTrendingFarmacos(
    {Address? address, limit = 10}) async {
  Uri uri = Helper.getUri('api/foods');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();

  _queryParams['limit'] = '$limit';
  // _queryParams['trending'] = 'week'; TODO re-add ("week" or "month")
  _queryParams['with'] = 'extras.extraGroup;extras';
  if (address != null && !address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    final jsonResponse = jsonDecode(streamedRest.body)['data'];
    return (jsonResponse as List)
        .map((data) => Farmaco.fromJSON(data))
        .toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<List<Farmaco>> getDiscountedFarmacos(
    {Address? address, limit = 10}) async {
  Uri uri = Helper.getUri('api/foods/sales');
  Map<String, dynamic> _queryParams = {};

  _queryParams['limit'] = '$limit';
  // _queryParams['trending'] = 'week'; TODO re-add ("week" or "month")
  _queryParams['with'] = 'extras.extraGroup;extras';
  if (address != null && !address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    final jsonResponse = jsonDecode(streamedRest.body)['data'];
    return (jsonResponse as List)
        .map((data) => Farmaco.fromJSON(data))
        .toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<Farmaco?> getFarmaco(String foodId) async {
  Uri uri = Helper.getUri('api/foods/$foodId');
  uri = uri.replace(queryParameters: {
    'with': 'extras;extras.extraGroup;foodReviews;foodReviews.user'
  });
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    final data = jsonDecode(streamedRest.body)['data'];
    return Farmaco.fromJSON(data);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return null;
  }
}

Future<List<Farmaco>> searchFarmacos(String search,
    {int offset = 0,
    Address? address,
    String? restaurant_id,
    String? categoryId,
    bool onSale = false,
    Map<String, dynamic>? filter}) async {
  Uri uri = Helper.getUri('api/foods');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  _queryParams['limit'] = '10';
  _queryParams['offset'] = '$offset';
  _queryParams['with'] = 'category;extras.extraGroup;extras';

  //_queryParams['on_sale']=onSale.toString();
  if (restaurant_id != null) {
    _queryParams['restaurant'] = '$restaurant_id';
  }
  if (categoryId != null) {
    _queryParams['categories[]'] = '$categoryId';
  }
  if (filter != null) {
    _queryParams.addAll(filter);
  }
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // Filter filter = Filter.fromJSON(
  //     json.decode(prefs.getString('filter') ?? '{}'));
  // _queryParams.addAll(filter.toQuery());
  // _queryParams.remove('cuisines[]');
  //
  if (address != null && !address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    final data = jsonDecode(streamedRest.body)['data'];
    return (data as List).map((data) {
      return Farmaco.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<List<Farmaco>> getFarmacosByCategory(String? categoryId,
    {offset = 0, bool inEvidenza = false, FilterProvider? filter}) async {
  Uri uri = Helper.getUri('api/items');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'restaurant;extras.extraGroup;extras';
  _queryParams['search'] = 'category_id:$categoryId';
  _queryParams['searchFields'] = 'category_id:=';
  if (inEvidenza) {
    _queryParams['search'] += ';featured:1';
    _queryParams['searchFields'] += ';featured:=';
    _queryParams['searchJoin'] = 'and';
  }
  _queryParams['limit'] = '10';
  _queryParams['offset'] = '$offset';
  if (filter != null) {
    _queryParams = filter.toQuery();
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    final jsonResponse = jsonDecode(streamedRest.body)['data'];
    print(uri);
    return (jsonResponse as List)
        .map((data) => Farmaco.fromJSON(data))
        .toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<Stream<Farmaco>> getFarmacosOfRestaurant(String restaurantId,
    {String? categories, limit = 10}) async {
  Uri uri = Helper.getUri('api/foods/categories');
  Map<String, dynamic> query = {
    'with': 'restaurant;category;extras;foodReviews;extras.extraGroup',
    'search': 'restaurant_id:$restaurantId',
    'searchFields': 'restaurant_id:=',
    'limit': '${limit}',
  };

  if (categories != null) {
    query['categories[]'] = [categories];
  }
  uri = uri.replace(queryParameters: query);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    print(uri);
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) {
      return Farmaco.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Farmaco.fromJSON({}));
  }
}

Future<Stream<Farmaco>> getTrendingFarmacosOfRestaurant(String restaurantId,
    {limit = 10}) async {
  Uri uri = Helper.getUri('api/foods');
  uri = uri.replace(queryParameters: {
    'with': 'category;extras;foodReviews;extras.extraGroup',
    'search': 'restaurant_id:$restaurantId',
    'searchFields': 'restaurant_id:=',
    'searchJoin': 'and',
    'trending': 'month',
    'limit': '${limit}',
  });
  // TODO Trending foods only
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    print(uri);
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) {
      return Farmaco.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Farmaco.fromJSON({}));
  }
}

Future<List<Farmaco>> getFeaturedFarmacosOfRestaurant(String restaurantId,
    {limit = 10}) async {
  Uri uri = Helper.getUri('api/foods');
  uri = uri.replace(queryParameters: {
    'with': 'extras;foodReviews;extras.extraGroup',
    'search': 'restaurant_id:$restaurantId;featured:1',
    'searchFields': 'restaurant_id:=;featured:=',
    'searchJoin': 'and',
    'limit': '${limit}',
  });
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    print(uri);
    final data = jsonDecode(streamedRest.body)['data'];
    return (data as List).map((data) {
      return Farmaco.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<List<Farmaco>> searchFoods(String search,
    {int offset = 0,
    Address? address,
    String? restaurant_id,
    String? categoryId,
    bool onSale = false,
    Map<String, dynamic>? filter}) async {
  Uri uri = Helper.getUri('api/items');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  _queryParams['limit'] = '10';
  _queryParams['offset'] = '$offset';
  _queryParams['with'] = 'category;extras.extraGroup;extras';

  //_queryParams['on_sale']=onSale.toString();
  if (restaurant_id != null) {
    _queryParams['restaurant'] = '$restaurant_id';
  }
  if (categoryId != null) {
    _queryParams['categories[]'] = '$categoryId';
  }
  if (filter != null) {
    _queryParams.addAll(filter);
  }
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // Filter filter = Filter.fromJSON(
  //     json.decode(prefs.getString('filter') ?? '{}'));
  // _queryParams.addAll(filter.toQuery());
  // _queryParams.remove('cuisines[]');
  //
  if (address != null && !address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    final data = jsonDecode(streamedRest.body)['data'];
    return (data as List).map((data) {
      return Farmaco.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<List<AppCategory>> searchCategories(String search,
    {int offset = 0,
    Address? address,
    String? categoryId,
    bool onSale = false,
    Map<String, dynamic>? filter}) async {
  Uri uri = Helper.getUri('api/categories');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  //_queryParams['on_sale']=onSale.toString();

  if (categoryId != null) {
    _queryParams['categories[]'] = '$categoryId';
  }
  //if (filter != null) {
  //   _queryParams.addAll(filter);
  //}
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // Filter filter = Filter.fromJSON(
  //     json.decode(prefs.getString('filter') ?? '{}'));
  // _queryParams.addAll(filter.toQuery());
  // _queryParams.remove('cuisines[]');
  //
  // if (address != null && !address.isUnknown()) {
  // _queryParams['myLon'] = address.longitude.toString();
  // _queryParams['myLat'] = address.latitude.toString();
  // _queryParams['areaLon'] = address.longitude.toString();
  // _queryParams['areaLat'] = address.latitude.toString();
  // }
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);

  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    print(streamedRest);
    final data = jsonDecode(streamedRest.body)['data'];
    print(data);
    return (data as List).map((data) {
      return AppCategory.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}
