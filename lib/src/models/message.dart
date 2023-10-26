import '../providers/user_provider.dart';
import 'media.dart';

class Message {
  String? id;
  bool from_user = false;
  String? chat_id;
  String? text;
  String? data;
  DateTime? updated_at;
  Media? content;
  bool messageRead = false;

  Message();

  Message.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      from_user = jsonMap['message_from'] == currentUser.value.id;
      chat_id = jsonMap['chat_id'].toString();
      text = jsonMap['text'];
      data = jsonMap['data'];
      updated_at = jsonMap['updated_at'] != null
          ? DateTime.parse(jsonMap['updated_at'])
          : DateTime.now();
      print(jsonMap['message_read']);
      messageRead = jsonMap['message_read'] ?? false;
      if (jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty) {
        print(jsonMap['media']);
        content = Media.fromJson((jsonMap['media'] as List).first);
        print(text);
        //text='Audio 🎵';
      }
    } catch (e, stack) {
      print("Message:$e");
      print(stack);
    }
    updated_at ??= DateTime.now();
    text ??= '';
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["text"] = text;
    map["chat_id"] = chat_id;
    map["message_from"] = currentUser.value.id;
    if (data != null) map["data"] = data.toString();
    return map;
  }
}
