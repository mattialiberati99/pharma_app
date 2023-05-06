import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_app/src/repository/user_repository.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'settings_repository.dart';

Future<List<Notification>> getNotifications() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return [];
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}notifications?${_apiToken}search=notifiable_id:${_user.id}&searchFields=notifiable_id:=&orderBy=created_at&sortedBy=desc&limit=10';

  final client = new http.Client();
  try {
    final streamedRest = await client.get(Uri.parse(url));
    final data = jsonDecode(streamedRest.body)['data'];
    return (data as List).map((data) {
      return Notification.fromJSON(data);
    }).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return [];
  }
}

Future<Notification> markAsReadNotifications(Notification notification) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Notification();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}notifications/${notification.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(notification.markReadMap()),
  );
  print(
      "[${response.statusCode}] NotificationRepository markAsReadNotifications");
  return Notification.fromJSON(json.decode(response.body)['data']);
}

Future<Notification> removeNotification(Notification notification) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Notification();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}notifications/${notification.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  print("[${response.statusCode}] NotificationRepository removenotification");
  return Notification.fromJSON(json.decode(response.body)['data']);
}
