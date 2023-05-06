import 'dart:convert';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/farmaco.dart';
import '../providers/filter_provider.dart';

Future<List<Farmaco>> getProductsByCategory(String? categoryId,
    {offset = 0, bool inEvidenza = false,FilterProvider? filter}) async {
  Uri uri = Helper.getUri('api/items');
  Map<String, dynamic> _queryParams = {};
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
  if(filter!=null) {
    _queryParams = filter.toQuery();
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.get(uri);
    final jsonResponse = jsonDecode(streamedRest.body)['data'];
    print("ITEMS BY CATEGORY: $uri");
    print("ITEMS BY CATEGORY RESPONSE: $jsonResponse");
    return (jsonResponse as List).map((data) => Farmaco.fromJSON(data)).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<Stream<Farmaco>> getProductsOfShopStream(String restaurantId,
    {String? categories, limit = 10}) async {
  Uri uri = Helper.getUri('api/items/categories');
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
    return Stream.value(Farmaco.fromJSON({}));
  }
}

Future<List<Farmaco>> getProductsOfShop(String shopId,String categoryId) async {
  final items = <Farmaco>[];
  await getProductsOfShopStream(shopId, categories: categoryId).then((value) => value.forEach((element) {
    items.add(element);
  }));
  return items;
}