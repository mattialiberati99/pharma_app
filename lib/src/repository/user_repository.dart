import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../helpers/custom_trace.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../repository/user_repository.dart' as userRepo;

Future<User> login(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}login';
  final client = http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  logger.info(url);
  logger.info(json.encode(user.toMap()));
  if (response.statusCode == 200) {
    logger.info(response.body);
    return User.fromJSON(json.decode(response.body)['data']);
  } else {
    logger.error(
        CustomTrace(StackTrace.current, message: response.body).toString());
    throw Exception(response.body);
  }
}

Future<User> loginSocial(User user, String token) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}social';
  var map = user.toMap();
  map["remember_token"] = token;
  final client = http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(map),
  );
  logger.info("loginSocial :: ${response.body}");
  if (response.statusCode == 200) {
    var decoded = json.decode(response.body);
    return User.fromJSON(decoded['data']);
  } else {
    logger.error(
        CustomTrace(StackTrace.current, message: response.body).toString());
    throw Exception(response.body);
  }
}

Future<User> register(User user) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    logger.info("Registrazione ok => ${user.toMap()}");
    return User.fromJSON(json.decode(response.body)['data']);
  } else {
    logger.error(
        CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<bool> resetPassword(User user) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}send_reset_link_email';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<User> update(User user) async {
  print(json.encode(user.toMap()));
  user.deviceToken = null;
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  // TODO user.deviceToken=null;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}users/${currentUser.value.id}?$_apiToken';

  print(url);

  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  return User.fromJSON(json.decode(response.body)['data']);
}

Future<User> loginAsUserToken(String token) async {
  final String _apiToken = 'api_token=${token}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}user?$_apiToken';
  final client = new http.Client();
  final response = await client.get(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return User.fromJSON(json.decode(response.body)['data']);
}

Future<bool> sendVerificationMail() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  logger.info(_apiToken);
  //address.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}send_validation_email?$_apiToken';
  final client = http.Client();
  try {
    final response = await client.post(
      Uri.parse(url),

      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      //body: json.encode(address.toMap()),
    );

    logger.info(url);
    //print(json.encode(address.toMap()));
    return response.statusCode == 200;
  } catch (e, stack) {
    logger.error(e);
    logger.error(stack);
    logger.error(CustomTrace(StackTrace.current, message: url));
    return false;
  }
}

Future<User?> validateUserCode(String text) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  //address.userId = _user.id;
  var map = <String, dynamic>{};
  map["code"] = text;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}validate_code?$_apiToken';
  final client = http.Client();
  try {
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(map),
    );
    logger.info(url);
    //print(json.encode(address.toMap()));
    return User.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    logger.error(e);
    //print(CustomTrace(StackTrace.current, message: url));
    return null;
  }
}

Future<bool> addUserImage() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}user_image?api_token=${currentUser.value.apiToken}';

  var uri = Uri.parse(url);
  var dioRequest = dio.Dio();
  // create multipart request
  var uuid = Uuid();
  dio.FormData formData = new dio.FormData.fromMap({
    "user_id": currentUser.value.id,
    "uuid": uuid.v4(),
    "field": "image",
    "file": await dio.MultipartFile.fromFile(currentUser.value.imagePath!,
        filename: currentUser.value.imagePath!.split('/').last)
  });
  print(uri);
  var response = await dioRequest.post(url, data: formData);
  // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
  print(response.statusCode);
  print(response.data.toString());
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<void> removeUserImage() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}remove_image?$_apiToken';
  final client = new http.Client();
  try {
    await client.get(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return;
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return;
  }
}

Future<bool> deleteUser() async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}users/${currentUser.value.id}?$_apiToken';
  print(url);
  final client = new http.Client();
  final response = await client.delete(
    Uri.parse(url),
  );
  print(url);
  //setCurrentUser(response.body);
  return json.decode(response.body)['success'];
}

Future<String?> getStripeAccount() async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}stripe_connected?$_apiToken';
  logger.info(url);
  final client = http.Client();
  final response = await client.get(
    Uri.parse(url),
  );
  logger.info(url);
  //setCurrentUser(response.body);
  final data = json.decode(response.body)['data'];
  return data?['code'] ?? '';
}
