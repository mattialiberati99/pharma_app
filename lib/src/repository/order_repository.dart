import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:pharma_app/src/repository/user_repository.dart';

import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/destination_object.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

Future<List<Order>> getOrders({String? date}) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return [];
  }
  String date_filter = "";
  if (date != null) date_filter = '&date_filter=${date}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}orders?';
  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = '${_user.apiToken}';
  _queryParams['with'] =
      'foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment;deliveryAddress';
  _queryParams['orderBy'] = 'id';

  _queryParams['sortedBy'] = 'desc';
  _queryParams['limit'] = '12';
  Uri uri = Uri.parse(url);
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  final client = new http.Client();
  final streamedRest = await client.get(uri);
  final data = jsonDecode(streamedRest.body)['data'];
  return (data as List).map((data) => Order.fromJSON(data)).toList();
}

Future<Order?> getOrder(orderId) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;deliveryAddress;payment';
  final r = RetryOptions(maxAttempts: 8);
  final response = await r.retry(
    // Make a GET request
    () => http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json'
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
  final body = json.decode(response.body)["data"];
  return Order.fromJSON(body);
  /*return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data as Map<String, dynamic>)).map((data) {
    return Order.fromJSON(data);
  });*/
}

Future<int> getOrdersCount({restaurant_id}) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return 0;
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders_count?';
  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = '${_user.apiToken}';
  if (restaurant_id != null) {
    _queryParams['restaurant'] = '$restaurant_id';
  }

  Uri uri = Uri.parse(url);
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  final client = new http.Client();
  final streamedRest = await client.get(uri);
  final data = jsonDecode(streamedRest.body)['data'];
  return data as int;
}

Future<Order?> getOrderOfRestaurant(restaurant_id) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  String url = 'api/orders';
  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = _user.apiToken;
  _queryParams['with'] =
      'user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;deliveryAddress;payment';
  _queryParams['search'] = 'foodOrders.food.restaurant.id!:$restaurant_id';
  _queryParams['searchFields'] = 'foodOrders.food.restaurant.id!:=';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['limit'] = '1';
  Uri uri = Helper.getUri(url);
  uri = uri.replace(queryParameters: _queryParams);

  final r = RetryOptions(maxAttempts: 8);
  final response = await r.retry(
    // Make a GET request
    () => http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json'
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
  print(uri);
  final body = json.decode(response.body)["data"];
  try {
    return (body as List).map((p) {
      print(p);
      return Order.fromJSON(p);
    }).first;
  } catch (e) {
    return null;
  }
  /*return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data as Map<String, dynamic>)).map((data) {
    return Order.fromJSON(data);
  });*/
}

Future<Order?> getLastOrder() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=1';
  final r = RetryOptions(maxAttempts: 8);
  final response = await r.retry(
    // Make a GET request
    () => http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json'
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
  final body = json.decode(response.body)["data"];
  return (body as List).map((p) {
    return Order.fromJSON(p);
  }).first;
}

Future<Stream<OrderStatus?>> getOrderStatus() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Stream<DestinationObject?>> getTrackingStatus(orderId) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}tracking/$orderId?${_apiToken}';
  final client = new http.Client();
  //print(url);
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .map((data) {
    return DestinationObject.fromJSON(data);
  });
}

Future<Order?> addOrder(Order order,
    {PaymentIntent? paymentIntentResult}) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return null;
  }
  order.payment = Payment('contanti');
  final String url = '${GlobalConfiguration().getValue('api_base_url')}orders';
  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = _user.apiToken;
  _queryParams['with'] =
      'foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment;deliveryAddress';
  Uri uri = Uri.parse(url).replace(queryParameters: _queryParams);
  final client = http.Client();
  Map params = order.toMap();
  if (paymentIntentResult != null) {
    params['client_secret'] = paymentIntentResult.clientSecret;
  }
  try {
    final response = await client.post(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(params),
    );
    print(uri);
    print(json.encode(params));
    return Order.fromJSON(json.decode(response.body)['data']);
  } catch (e, stack) {
    print(e);
    print(stack);
    return null;
  }
}

Future<Order> cancelOrder(Order order) async {
  User _user = currentUser.value;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders/${order.id}';
  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = _user.apiToken;
  _queryParams['with'] =
      'foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment;deliveryAddress';
  Uri uri = Uri.parse(url).replace(queryParameters: _queryParams);
  final client = new http.Client();
  print(uri);
  print(json.encode(order.cancelMap()));
  final response = await client.put(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.cancelMap()),
  );
  if (response.statusCode == 200) {
    return Order.fromJSON(json.decode(response.body)['data']);
  } else {
    throw new Exception(response.body);
  }
}

Future<Map> getPaymentIntent(Order order) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}get_payment_intent?$_apiToken';
  final client = new http.Client();
  Map params = order.toMap();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['data'];
  } else {
    print(response.body);
    throw new Exception(response.body);
  }
}
