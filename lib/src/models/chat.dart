import '/src/models/user.dart';
import 'message.dart';

class Chat {
  String? id;

  // conversation name for example chat with restaurant name
  String? name;
  User? other;

  // Chats messages
  Message? lastMessage;

  List<Message> messages = [];
  DateTime? created_at;

  int non_read_count = 0;

  Chat() {}

  Chat.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      name = jsonMap['name'] != null ? jsonMap['name'].toString() : '';
      other = jsonMap['other'] != null
          ? User.fromJSON(jsonMap['other'])
          : User.fromJSON({});
      lastMessage = jsonMap['last_message'] != null
          ? Message.fromJSON(jsonMap['last_message'])
          : null;

      if (jsonMap['messages'] != null) {
        (jsonMap['messages'] as List).forEach((element) {
          messages.add(Message.fromJSON(element));
        });
      }
      created_at = DateTime.parse(jsonMap['created_at']);
      non_read_count = jsonMap['non_read_count'];
    } catch (e, stack) {
      print("Chat: $e");
      print(stack);
      id = '';
      name = '';

      lastMessage = Message.fromJSON({});
      created_at = DateTime.now();
    }
  }
}
