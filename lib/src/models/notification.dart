import 'dart:convert';

import '../helpers/custom_trace.dart';

class Notification {
  String? id;
  String? type;
  Map<String, dynamic> data = Map();
  bool? read;
  DateTime? createdAt;

  Notification({this.id,this.type,this.data=const {},this.read,this.createdAt});

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      data = jsonMap['data'] != null ? jsonDecode(jsonMap['data']) : {};
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = DateTime.parse(jsonMap['created_at']);
    } catch (e) {
      id = '';
      type = '';
      data = {};
      read = false;
      createdAt = new DateTime(0);
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read!;
    return map;
  }
}
