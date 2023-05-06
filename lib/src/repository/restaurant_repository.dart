import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_app/src/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/favorite_restaurant.dart';
import '../models/filter.dart';
import '../models/shop.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

ValueNotifier<List<String>> recentRestaurants = ValueNotifier(<String>[]);

Future<List<Shop>> getNearRestaurants(Address myLocation, Address areaLocation,
    {offset = 0}) async {
  Uri uri = Helper.getUri('api/shops');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['limit'] = '20';
  _queryParams['offset'] = '$offset';
  try {
    //if (!myLocation.isUnknown() && !areaLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
    _queryParams['areaLon'] = areaLocation.longitude.toString();
    _queryParams['areaLat'] = areaLocation.latitude.toString();
    //}
  } catch (e) {}
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  print("GET NEAR SHOPS: $uri");
  try {
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
      () => http.get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      }).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var responseJson = json.decode(response.body)["data"];
    //print("NEAR SHOPS RESPONSE: $responseJson");
    return (responseJson as List).map((p) {
      Shop restaurant = Shop.fromJSON(p);
      try {
        restaurant.distance = distanceBetween(
                myLocation.latitude!,
                myLocation.longitude!,
                double.tryParse(restaurant.latitude!)!,
                double.tryParse(restaurant.longitude!)!) /
            1000;
      } catch (e) {}
      return restaurant;
    }).toList();
    /*return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data as Map<String, dynamic>)).expand((data) => (data as List)).map((data) {
      Restaurant restaurant= Restaurant.fromJSON(data);
      try {
        restaurant.distance = distanceBetween(
            myLocation.latitude ?? double.tryParse(restaurant.latitude),
            myLocation.longitude ?? double.tryParse(restaurant.longitude),
            double.tryParse(restaurant.latitude),
            double.tryParse(restaurant.longitude)) / 1000;
      }catch(e){}
      print(restaurant.toMap());
      return restaurant;
    });*/
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}

double distanceBetween(
  double startLatitude,
  double startLongitude,
  double endLatitude,
  double endLongitude,
) {
  var earthRadius = 6378137.0;
  var dLat = _toRadians(endLatitude - startLatitude);
  var dLon = _toRadians(endLongitude - startLongitude);

  var a = pow(sin(dLat / 2), 2) +
      pow(sin(dLon / 2), 2) *
          cos(_toRadians(startLatitude)) *
          cos(_toRadians(endLatitude));
  var c = 2 * asin(sqrt(a));

  return earthRadius * c;
}

_toRadians(double degree) {
  return degree * pi / 180;
}

Future<List<Shop>> getPopularRestaurants(Address myLocation, {limit}) async {
  Uri uri = Helper.getUri('api/shops');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  if (limit != null) {
    _queryParams['limit'] = '$limit';
  }
  _queryParams['popular'] = 'all';
  if (!myLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
  }
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  print("GET POPULAR RESTAURANTS: $uri");
  try {
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
      () => http.get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      }).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var responseJson = json.decode(response.body)["data"];
    print("POPULAR RESTAURANTS RESPONSE: $responseJson");
    return (responseJson as List).map((p) {
      Shop restaurant = Shop.fromJSON(p);
      try {
        restaurant.distance = distanceBetween(
                myLocation.latitude!,
                myLocation.longitude!,
                double.tryParse(restaurant.latitude!)!,
                double.tryParse(restaurant.longitude!)!) /
            1000;
      } catch (e) {}
      return restaurant;
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [Shop.fromJSON({})];
  }
}

Future<List<Shop>> loadRecentRestaurants() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.remove('recents');
  List<String> recents = prefs.getStringList('recents') as List<String>;
  print(recents);
  try {
    List<Shop> recentRest = [];
    for (String element in recents) {
      Shop? stream = await getRestaurant(
        element,
      );
      recentRest.add(stream!);
    }
    print("return ${recentRest.length}");
    return recentRest;
  } catch (e, stack) {
    print(e);
    print(stack);
    return [];
  }
}

void saveRecentRestaurants() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (recentRestaurants.value.length > 4) recentRestaurants.value.removeAt(0);
  print("RECENTSSS");
  prefs.setStringList('recents', recentRestaurants.value);

  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  recentRestaurants.notifyListeners();
}

Future<List<Shop>> searchRestaurants(String search,
    {int offset = 0, Address? address}) async {
  Uri uri = Helper.getUri('api/shops');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams.addAll(filter.toQuery());
  _queryParams.remove('cuisines[]');
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  _queryParams['limit'] = '10';
  _queryParams['offset'] = '$offset';

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
      return Shop.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }

  // final streamedRest = await client.send(http.Request('get', uri));

  //   return streamedRest.stream
  //       .transform(utf8.decoder)
  //       .transform(json.decoder)
  //       .map((data) => Helper.getData(data as Map<String, dynamic>))
  //       .expand((data) => (data as List))
  //       .map((data) {
  //     return Shop.fromJSON(data);
  //   });
  // } catch (e) {
  //   print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
  //   return new Stream.value(new Shop.fromJSON({}));
  // }
}

Future<Shop?> getRestaurant(String id, {Address? address}) async {
  Uri uri = Helper.getUri('api/restaurants/$id');
  Map<String, dynamic> _queryParams = {};
  if (address != null && !address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  _queryParams['with'] = 'users';
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = http.Client();
    final streamedRest = await client.get(uri);
    final data = jsonDecode(streamedRest.body)['data'];
    return Shop.fromJSON(data);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return null;
  }
}

Future<Stream<Review>> getRestaurantReviews(String id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews?search=restaurant_id:$id';
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    //print(url);
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Stream.value(Review.fromJSON({}));
  }
}

Future<Stream<Review>> getRecentReviews() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews?orderBy=updated_at&sortedBy=desc&limit=3';
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Stream.value(Review.fromJSON({}));
  }
}

Future<Review?> addRestaurantReview(Review review, Shop restaurant) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews?api_token=${currentUser.value.apiToken}';

  var uri = Uri.parse(url);
  var dioRequest = dio.Dio();
  var uuid = const Uuid();

  // create multipart request
  var request = http.MultipartRequest("POST", uri);
  dio.FormData formData;
  if (review.imagePath == null) {
    formData = dio.FormData.fromMap({
      "user_id": currentUser.value.id,
      "review": review.review,
      "rate": review.rate,
      "restaurant_id": restaurant.id!,
      "username": currentUser.value.name,
    });
  } else {
    formData = dio.FormData.fromMap({
      "user_id": currentUser.value.id,
      "review": review.review,
      "rate": review.rate,
      "restaurant_id": restaurant.id!,
      "username": currentUser.value.name,
      "uuid": uuid.v4(),
      "field": "image",
      "file": await dio.MultipartFile.fromFile(review.imagePath!,
          filename: review.imagePath!.split('/').last)
    });
  }

  var response = await dioRequest.post(url, data: formData);
  // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
  print(response.statusCode);
  print(response.data.toString());
  if (response.statusCode == 200) {
    return Review.fromJSON(response.data["data"]);
  } else {
    return null;
  }
}

Future<Review> getRestaurantReview(String restaurant_id) async {
  Uri uri = Helper.getUri('api/restaurant_reviews');
  uri = uri.replace(queryParameters: {
    'search': 'restaurant_id:${restaurant_id};user_id:${currentUser.value.id}',
    'searchFields': 'restaurant_id:=;user_id:=',
    'searchJoin': 'and',
  });
  final client = http.Client();
  //review.user_id = userRepo.currentUser.value.id;
  try {
    final response = await client.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      //body: json.encode(review.ofFarmacoToMap(food)),
    );
    print(uri);
    if (response.statusCode == 200) {
      try {
        return (json.decode(response.body)["data"] as List)
            .map((p) => Review.fromJSON(p))
            .first;
      } catch (e) {
        return Review.init(0);
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.init(0);
    }
  } catch (e) {
    print(e);
    print(CustomTrace(StackTrace.current, message: e.toString()).toString());
    return Review.init(0);
  }
}

Future<Stream<FavoriteRestaurant?>> isFavoriteRestaurant(
    String restaurantId) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}favorite_restaurants/exist?${_apiToken}restaurant_id=$restaurantId&user_id=${_user.id}';
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getObjectData(data as Map<String, dynamic>))
        .map((data) => FavoriteRestaurant.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Stream.value(FavoriteRestaurant.fromJSON({}));
  }
}

Future<List<FavoriteRestaurant>> getFavoriteRestaurants() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return [];
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}favorite_restaurants?${_apiToken}with=restaurants;restaurants.media;user&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = http.Client();
  final response = await client.get(Uri.parse(url));
  print(url);
  var responseJson = json.decode(response.body)['data'];

  try {
    return (responseJson as List).map((p) {
      return FavoriteRestaurant.fromJSON(p);
    }).toList();
  } catch (e, stack) {
    print(stack);
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
}

Future<FavoriteRestaurant> addFavoriteRestaurant(
    FavoriteRestaurant favorite) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return FavoriteRestaurant();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}favorite_restaurants?$_apiToken';
  try {
    final client = http.Client();
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(favorite.toMap()),
    );
    return FavoriteRestaurant.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return FavoriteRestaurant.fromJSON({});
  }
}

Future<FavoriteRestaurant> removeFavoriteRestaurant(
    FavoriteRestaurant favorite) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return FavoriteRestaurant();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}favorite_restaurants/${favorite.id}?$_apiToken';
  try {
    final client = http.Client();
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return FavoriteRestaurant.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return FavoriteRestaurant.fromJSON({});
  }
}

Future<List<Shop>> getRestaurantsOfCuisine(String? cuisineId,
    {int offset = 0, Address? address}) async {
  Uri uri = Helper.getUri('api/shops');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  Filter filter = Filter();

  _queryParams.addAll(filter.toQuery());
  _queryParams['cuisines[]'] = cuisineId;

  if (address != null && !address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);

  try {
    final client = http.Client();
    final streamedRest = await client.get(uri);
    final data = jsonDecode(streamedRest.body)['data'];
    print("SHOPS OF CUISINE $cuisineId LIST of ${(data as List).length}: $uri");

    return (data as List).map((data) {
      return Shop.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return [];
  }
}
