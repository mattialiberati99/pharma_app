import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/cuisine.dart';

ValueNotifier<List<String>> selectedCuisines =  ValueNotifier(<String>[]);

Future<Stream<Cuisine>> getCuisines({parents = false}) async {
  String url = '${GlobalConfiguration().getValue('api_base_url')}cuisines?orderBy=id&sortedBy=asc';
  if (parents) url = url + "&parent_id=null";
  print("CUISINES: $url");
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) {
    return Cuisine.fromJSON(data);
  });
}

Future<Stream<Cuisine>> getSubCuisines(String cuisineId) async {
  Uri uri = Helper.getUri('api/cuisines');
  Map<String, dynamic> _queryParams = {};
  _queryParams['parent_id'] = cuisineId;
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    print("SUB-CUISINES: $uri");
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) => Cuisine.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Cuisine.fromJSON({}));
  }
}

Future<List<Cuisine>> getCuisinesList() async {
  final cuisines = <Cuisine>[];
  await getCuisines().then((value) => value.forEach((element) {
    cuisines.add(element);
  }));
  return cuisines;
}


