import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/category.dart';
import '../models/filter.dart';


Future<List<AppCategory>> getCategories() async {
  Uri uri = Helper.getUri('api/categories');
  try {
    final client = http.Client();
    print(uri);
    final streamedRest = await client.get(uri);
    final jsonResp=jsonDecode(streamedRest.body)['data'];

    return (jsonResp as List)
        .map((data) => AppCategory.fromJSON(data)).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<Stream<AppCategory>> getCategory(String? id) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}categories/$id';
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .map((data) => AppCategory.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Stream.value(AppCategory.fromJSON({}));
  }
}

Future<List<AppCategory>> getCategoriesOfCuisine(String? cuisineId, {int offset = 0, Address? address}) async {
  Uri uri = Helper.getUri('api/categories');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  Filter filter = Filter();

  _queryParams.addAll(filter.toQuery());
  _queryParams['cuisines[]'] = cuisineId;
  uri = uri.replace(queryParameters: _queryParams);

  try {
    final client = http.Client();
    final streamedRest = await client.get(uri);
    final data = jsonDecode(streamedRest.body)['data'];
    print("CATEGORIES OF CUISINE $cuisineId LIST of ${(data as List).length}: $uri");

    return (data as List).map((data) {
      return AppCategory.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

Future<Stream<AppCategory>> getCategoriesOfRestaurantStream(String restaurantId) async {
  Uri uri = Helper.getUri('api/categories');
  Map<String, dynamic> _queryParams = {'restaurant_id': restaurantId};

  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) => AppCategory.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return Stream.value(AppCategory.fromJSON({}));
  }
}

Future<List<AppCategory>> getCategoriesOfRestaurant(String restaurantId) async {
  final categories = <AppCategory>[];
  await getCategoriesOfRestaurantStream(restaurantId).then((value) => value.forEach((element) {
    categories.add(element);
  }));
  print("CATEGORIES OF SHOP $restaurantId LIST of ${categories.length}");
  for( final c in categories){
    print('${categories.elementAt(categories.indexOf(c)).name} - ${categories.elementAt(categories.indexOf(c)).id}');

  }
  return categories;
}