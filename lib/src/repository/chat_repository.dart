import 'dart:convert';
import 'dart:io';

import '../providers/user_provider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart' as dio;
import '../helpers/custom_trace.dart';
import '../models/chat.dart';
import 'package:http/http.dart' as http;

import '../models/message.dart';

Future<List<Chat>> getUserChats({int offset = 0}) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}chats';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = currentUser.value.apiToken;
  _queryParams['limit'] = '10';
  _queryParams['offset'] = '$offset';
  _queryParams['orderBy'] = 'created_at';
  _queryParams['sortedBy'] = 'desc';
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);

  final client = new http.Client();
  final streamedRest = await client.get(uri);
  final data = jsonDecode(streamedRest.body)['data'];
  try {
    return (data as List).map((data) => Chat.fromJSON(data)).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
}

Future<Chat> getUserChat(String chatId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}chats/${chatId}';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.get(uri);
  try {
    print(uri);
    return Chat.fromJSON(jsonDecode(streamedRest.body)["data"]);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Chat.fromJSON({});
  }
}

Future<List<Message>> getChatMessages(String chat_id, int offset) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}messages';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;
  _queryParams['limit'] = '20';
  _queryParams['offset'] = '$offset';
  _queryParams['search'] = 'chat_id:$chat_id';
  _queryParams['searchFields'] = 'chat_id:=';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.get(uri);
  try {
    print(uri);
    var body = jsonDecode(streamedRest.body)['data'];

    return (body as List).map((p) => Message.fromJSON(p)).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
}

Future<Message?> getChatMessage(String chat_id, String message_id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}messages/$message_id';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;

  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.get(uri);
  try {
    print(uri);
    var body = jsonDecode(streamedRest.body)['data'];

    return Message.fromJSON(body);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}

Future<List<Message>> getNewMessages(
    String chat_id, String message_id, String part_id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}messages';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;
  _queryParams['limit'] = '3';
  _queryParams['offset'] = '0';
  _queryParams['search'] =
      'id:$message_id;chat_id:$chat_id;partecipant_id:$part_id';
  _queryParams['searchFields'] = 'id:>;chat_id:=;partecipant_id:=';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['searchJoin'] = 'and';
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.get(uri);
  try {
    print(uri);
    var body = jsonDecode(streamedRest.body)['data'];

    return (body as List).map((p) => Message.fromJSON(p)).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
}

Future<Message> pushMessage(Message message) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}messages';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.post(uri, body: message.toMap());
  try {
    print(uri);
    print(json.encode(message.toMap()));
    print(streamedRest.body);
    return Message.fromJSON(jsonDecode(streamedRest.body)["data"]);
  } catch (e, stack) {
    print(stack);
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Message.fromJSON({});
  }
}

Future<Message> pushContentMessage(Message message) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}messages';

  var dioRequest = dio.Dio();

  dio.FormData formData = new dio.FormData.fromMap({
    "api_token": currentUser.value.apiToken,
    "chat_id": message.chat_id,
    "message_from": currentUser.value.id
  });

  formData.files.add(MapEntry(
      "files[]",
      await dio.MultipartFile.fromFile(message.data!,
          filename: p.basename(message.data!))));
  print(url);
  formData.fields.forEach((element) {print( element.key+" - "+element.value);});
  var response = await dioRequest.post(
    url,
    data: formData,
    options: dio.Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 800;
      },
    ),
  );


  if (response.statusCode == 200) {
    return Message.fromJSON(response.data["data"]);
  } else {
    return Message.fromJSON({});
  }
}

Future<Chat?> checkChatWithUser(String userId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}chat_exists';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = currentUser.value.apiToken;
  _queryParams['user_id'] = userId;
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.get(uri);
  final body = json.decode(streamedRest.body)['data'];
  try {
    print(uri);
    return Chat.fromJSON(body);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}

Future<Chat?> createNewChat(otherId, {public = false}) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}chats';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;
  _queryParams['other_id'] = otherId;
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.post(uri);
  try {
    print(uri);
    return Chat.fromJSON(jsonDecode(streamedRest.body)["data"]);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return null;
  }
}


Future<bool> deleteChat(id) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}chats/${id}?$_apiToken';
  try {
    print(url);
    final client = new http.Client();
    await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return true;
  } catch (e) {
    print(e);
    print(CustomTrace(StackTrace.current, message: url).toString());
    return false;
  }
}

Future<List<Message>> loadUnreadMessages() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}unread_messages';

  var uri = Uri.parse(url);

  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;

  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  final client = new http.Client();
  final streamedRest = await client.get(uri);
  try {
    var body = jsonDecode(streamedRest.body)['data'];
    return (body as List).map((e) => Message.fromJSON(e)).toList();
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return [];
  }
}

void setMessagesOfChatRead(chatId) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}read_chat/${chatId}?$_apiToken';
  try {
    print(url);
    final client = new http.Client();
    await client.get(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
  } catch (e) {
    print(e);
    print(CustomTrace(StackTrace.current, message: url).toString());
  }
}